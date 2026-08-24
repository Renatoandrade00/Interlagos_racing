extends VehicleBody3D
class_name VehicleBase

@export var data: VehicleData
@export var is_player_controlled: bool = true

# Nós das rodas
@onready var wheel_fl: VehicleWheel3D = $WheelFL
@onready var wheel_fr: VehicleWheel3D = $WheelFR
@onready var wheel_rl: VehicleWheel3D = $WheelRL
@onready var wheel_rr: VehicleWheel3D = $WheelRR

# Estado do trem de força (Powertrain)
# Marchas: 0 = R (Ré), 1 = N (Neutro), 2 = 1ª, 3 = 2ª, 4 = 3ª, 5 = 4ª, 6 = 5ª, 7 = 6ª
var current_gear_idx: int = 2
var current_rpm: float = 950.0
var current_speed_kmh: float = 0.0
var longitudinal_speed_kmh: float = 0.0
var current_steer_target: float = 0.0
var is_automatic: bool = true

# Controle de trocas de marcha e embreagem
var is_shifting: bool = false
var shift_timer: float = 0.0
const SHIFT_DURATION: float = 0.15

# Telemetria & Debug
var telemetry: Dictionary = {}

func _ready() -> void:
	if not data:
		data = preload("res://Vehicles/car_proto_rwd.tres")
	apply_vehicle_data()

func apply_vehicle_data() -> void:
	mass = data.mass
	center_of_mass = data.center_of_mass_offset
	
	for w in [wheel_fl, wheel_fr, wheel_rl, wheel_rr]:
		if w:
			w.suspension_travel = data.suspension_travel
			w.suspension_stiffness = data.suspension_stiffness
			w.damping_compression = data.suspension_damping
			w.damping_relaxation = data.suspension_damping * 1.3
			w.wheel_friction_slip = data.tire_friction_slip
			w.wheel_roll_influence = 0.08

func _physics_process(delta: float) -> void:
	# Velocidade longitudinal no referencial do carro (no Godot -Z é a frente)
	var forward_dir = -global_transform.basis.z.normalized()
	var fwd_speed_ms = linear_velocity.dot(forward_dir)
	longitudinal_speed_kmh = fwd_speed_ms * 3.6
	current_speed_kmh = abs(longitudinal_speed_kmh)
	
	if is_player_controlled:
		process_player_input(delta)
	
	process_powertrain(delta)
	update_telemetry()

func process_player_input(delta: float) -> void:
	var throttle_in = Input.get_action_raw_strength("throttle")
	var brake_in = Input.get_action_raw_strength("brake")
	var handbrake_in = 1.0 if Input.is_action_pressed("handbrake") else 0.0
	
	# --- SISTEMA DE CÂMBIO AUTOMÁTICO INTELIGENTE (ESTILO GT4) ---
	if is_automatic:
		# Se estiver parado ou quase parado (< 3 km/h) e segurar freio, engata Ré
		if brake_in > 0.2 and longitudinal_speed_kmh < 3.0 and current_gear_idx >= 2 and longitudinal_speed_kmh > -2.0:
			current_gear_idx = 0 # Engata Ré (R)
		# Se estiver em Ré e apertar acelerador, engata 1ª marcha
		elif throttle_in > 0.2 and current_gear_idx == 0 and longitudinal_speed_kmh > -3.0:
			current_gear_idx = 2 # Engata 1ª marcha
	
	# --- ESTERÇO COM SENSIBILIDADE DINÂMICA À VELOCIDADE ---
	var steer_in = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var speed_factor = clamp(1.0 - (current_speed_kmh / 280.0) * 0.55, 0.32, 1.0)
	var max_steer_rad = deg_to_rad(data.steer_limit_deg * speed_factor)
	current_steer_target = steer_in * max_steer_rad
	
	# Retorno rápido ao centro para precisão
	var steer_rate = data.steer_speed
	if abs(steer_in) < 0.05:
		steer_rate *= 1.8
	steering = move_toward(steering, current_steer_target, steer_rate * delta)
	
	# --- TRANSMISSÃO DE FORÇA E FRENAGEM ---
	var throttle_curve = throttle_in * throttle_in
	var brake_curve = brake_in * brake_in
	
	if current_gear_idx == 0:
		# Modo RÉ (R)
		# O freio atua como acelerador de ré
		var rev_drive = brake_curve * data.max_engine_force * 0.6
		var rev_brake = throttle_curve * data.max_brake_force
		engine_force = -rev_drive
		brake = rev_brake + (handbrake_in * data.max_brake_force)
	elif current_gear_idx == 1:
		# Modo NEUTRO (N)
		engine_force = 0.0
		brake = (brake_curve + handbrake_in) * data.max_brake_force
	else:
		# Modo DRIVE (Marchas para frente 1ª a 6ª)
		if is_shifting:
			engine_force = 0.0
		else:
			# Curva de torque do motor baseada em RPM
			var torque_factor = get_engine_torque_factor(current_rpm)
			var gear_mult = abs(data.gear_ratios[current_gear_idx]) / 3.8
			var effective_drive = throttle_curve * data.max_engine_force * torque_factor * clamp(gear_mult, 0.6, 1.2)
			engine_force = effective_drive
		
		# Frenagem progressiva nas marchas à frente
		brake = (brake_curve * data.max_brake_force) + (handbrake_in * data.max_brake_force * 0.8)
	
	# Reset do carro se capotar
	if Input.is_action_just_pressed("reset_car"):
		reset_vehicle_orientation()

func get_engine_torque_factor(rpm: float) -> float:
	# Curva de torque de superesportivo: pico entre 4500 e 6800 RPM
	var norm_rpm = clamp((rpm - data.idle_rpm) / (data.redline_rpm - data.idle_rpm), 0.0, 1.0)
	if norm_rpm < 0.5:
		return lerp(0.72, 1.0, norm_rpm * 2.0)
	elif norm_rpm < 0.85:
		return 1.0
	else:
		return lerp(1.0, 0.82, (norm_rpm - 0.85) / 0.15)

func process_powertrain(delta: float) -> void:
	# Gerenciamento do temporizador de troca de marcha
	if is_shifting:
		shift_timer -= delta
		if shift_timer <= 0.0:
			is_shifting = false
	
	var throttle_in = Input.get_action_raw_strength("throttle") if is_player_controlled else 1.0
	var gear_ratio = data.gear_ratios[current_gear_idx]
	
	if current_gear_idx == 0:
		# Em Marcha Ré
		var target_rpm = lerp(data.idle_rpm, data.redline_rpm * 0.75, Input.get_action_raw_strength("brake") if is_player_controlled else 0.5)
		current_rpm = lerp(current_rpm, max(data.idle_rpm, target_rpm), 12.0 * delta)
	elif current_gear_idx == 1:
		# Em Ponto Morto (Neutro)
		var target_rpm = lerp(data.idle_rpm, data.redline_rpm, throttle_in)
		current_rpm = lerp(current_rpm, target_rpm, 15.0 * delta)
	else:
		# Marchas para frente (1ª a 6ª)
		# Velocidade da roda convertida para RPM teórico do motor
		var wheel_rpm = 0.0
		if wheel_rl and wheel_rr:
			wheel_rpm = (abs(wheel_rl.get_rpm()) + abs(wheel_rr.get_rpm())) * 0.5
		
		var mechanical_rpm = wheel_rpm * gear_ratio * data.final_drive
		
		# Simulação de embreagem e resposta ao acelerador na arrancada (estilo GT4)
		if current_speed_kmh < 18.0 and current_gear_idx == 2:
			# Arrancada em 1ª: o motor sobe giro com o acelerador enquanto a embreagem patina
			var clutch_target_rpm = lerp(data.idle_rpm, data.redline_rpm * 0.65, throttle_in)
			var target_rpm = max(mechanical_rpm, clutch_target_rpm)
			current_rpm = lerp(current_rpm, clamp(target_rpm, data.idle_rpm, data.redline_rpm), 14.0 * delta)
		else:
			# Em movimento engatado: RPM acoplado rigidamente à velocidade da roda
			var target_rpm = max(mechanical_rpm, data.idle_rpm)
			# Se o acelerador estiver pressionado, responde mais rápido
			var lerp_speed = 18.0 if throttle_in > 0.1 else 8.0
			current_rpm = lerp(current_rpm, clamp(target_rpm, data.idle_rpm, data.redline_rpm), lerp_speed * delta)
		
		# --- TROCAS AUTOMÁTICAS DE MARCHA COM HISTERESE ---
		if is_automatic and not is_shifting:
			# Subir marcha (Upshift) próximo ao corte de giro
			if current_rpm > data.redline_rpm * 0.88 and current_gear_idx < data.gear_ratios.size() - 1:
				perform_gear_shift(current_gear_idx + 1)
			# Reduzir marcha (Downshift) quando o giro cai muito
			elif current_rpm < data.idle_rpm * 2.2 and current_gear_idx > 2:
				perform_gear_shift(current_gear_idx - 1)

func perform_gear_shift(new_gear: int) -> void:
	current_gear_idx = new_gear
	is_shifting = true
	shift_timer = SHIFT_DURATION
	# Queda instantânea de RPM no upshift para sensação realista de corte
	current_rpm *= 0.78

func reset_vehicle_orientation() -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_transform.origin += Vector3(0, 1.5, 0)
	rotation.x = 0.0
	rotation.z = 0.0

func update_telemetry() -> void:
	# Representação da marcha no HUD: -1 = R, 0 = N, 1 = 1ª, 2 = 2ª...
	var display_gear = current_gear_idx - 1
	if current_gear_idx == 0:
		display_gear = -1 # R
	elif current_gear_idx == 1:
		display_gear = 0  # N
	
	telemetry = {
		"speed_kmh": current_speed_kmh,
		"longitudinal_speed_kmh": longitudinal_speed_kmh,
		"rpm": current_rpm,
		"gear": display_gear,
		"steering": rad_to_deg(steering),
		"slip_fl": wheel_fl.get_skidinfo() if wheel_fl else 1.0,
		"slip_fr": wheel_fr.get_skidinfo() if wheel_fr else 1.0,
		"slip_rl": wheel_rl.get_skidinfo() if wheel_rl else 1.0,
		"slip_rr": wheel_rr.get_skidinfo() if wheel_rr else 1.0
	}
