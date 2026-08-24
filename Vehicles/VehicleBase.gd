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
const SHIFT_DURATION: float = 0.12

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
		# Se estiver parado (< 3 km/h) e segurar freio, engata Ré (R)
		if brake_in > 0.25 and current_speed_kmh < 3.0 and current_gear_idx >= 2:
			current_gear_idx = 0 # Engata Ré (R)
		# Se estiver em Ré e apertar acelerador, engata 1ª marcha para frente
		elif throttle_in > 0.25 and current_gear_idx == 0 and current_speed_kmh < 3.0:
			current_gear_idx = 2 # Engata 1ª marcha
	
	# --- ESTERÇO COM SENSIBILIDADE DINÂMICA À VELOCIDADE ---
	var steer_in = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var speed_factor = clamp(1.0 - (current_speed_kmh / 280.0) * 0.55, 0.32, 1.0)
	var max_steer_rad = deg_to_rad(data.steer_limit_deg * speed_factor)
	current_steer_target = steer_in * max_steer_rad
	
	# Retorno rápido ao centro para estabilidade em retas
	var steer_rate = data.steer_speed
	if abs(steer_in) < 0.05:
		steer_rate *= 1.8
	steering = move_toward(steering, current_steer_target, steer_rate * delta)
	
	# --- APLICAÇÃO DE FORÇA E FRENAGEM COM DIREÇÃO CORRETA ---
	var throttle_curve = throttle_in * throttle_in
	var brake_curve = brake_in * brake_in
	
	if current_gear_idx == 0:
		# ===== MODO RÉ (R) =====
		# No Godot VehicleBody3D, força POSITIVA empurra para TRÁS (+Z)
		var rev_force = brake_curve * data.max_engine_force * 0.65
		engine_force = rev_force
		# O acelerador normal atua como freio na ré
		var rev_brake = throttle_curve * data.max_brake_force
		brake = rev_brake + (handbrake_in * data.max_brake_force)
	elif current_gear_idx == 1:
		# ===== MODO NEUTRO (N) =====
		engine_force = 0.0
		brake = (brake_curve + handbrake_in) * data.max_brake_force
	else:
		# ===== MODO DRIVE (1ª a 6ª Marcha para Frente) =====
		if is_shifting:
			engine_force = 0.0
		else:
			# Curva de torque baseada em RPM
			var torque_factor = get_engine_torque_factor(current_rpm)
			var gear_mult = abs(data.gear_ratios[current_gear_idx]) / 3.8
			var effective_drive = throttle_curve * data.max_engine_force * torque_factor * clamp(gear_mult, 0.65, 1.25)
			# No Godot VehicleBody3D, força NEGATIVA empurra para FRENTE (-Z)
			engine_force = -effective_drive
		
		# Freio normal nas marchas para frente
		brake = (brake_curve * data.max_brake_force) + (handbrake_in * data.max_brake_force * 0.8)
	
	# Reset do carro se capotar
	if Input.is_action_just_pressed("reset_car"):
		reset_vehicle_orientation()

func get_engine_torque_factor(rpm: float) -> float:
	# Curva de torque de superesportivo V12: entrega linear com pico entre 4500 e 7200 RPM
	var norm_rpm = clamp((rpm - data.idle_rpm) / (data.redline_rpm - data.idle_rpm), 0.0, 1.0)
	if norm_rpm < 0.45:
		return lerp(0.75, 1.0, norm_rpm / 0.45)
	elif norm_rpm < 0.88:
		return 1.0
	else:
		return lerp(1.0, 0.85, (norm_rpm - 0.88) / 0.12)

func process_powertrain(delta: float) -> void:
	if is_shifting:
		shift_timer -= delta
		if shift_timer <= 0.0:
			is_shifting = false
	
	var throttle_in = Input.get_action_raw_strength("throttle") if is_player_controlled else 1.0
	var brake_in = Input.get_action_raw_strength("brake") if is_player_controlled else 0.0
	var gear_ratio = data.gear_ratios[current_gear_idx]
	
	if current_gear_idx == 0:
		# Em Ré: RPM responde ao pedal de ré (brake_in)
		var target_rpm = lerp(data.idle_rpm, data.redline_rpm * 0.7, brake_in)
		current_rpm = lerp(current_rpm, max(data.idle_rpm, target_rpm), 12.0 * delta)
	elif current_gear_idx == 1:
		# Em Neutro: corta giro livremente
		var target_rpm = lerp(data.idle_rpm, data.redline_rpm, throttle_in)
		current_rpm = lerp(current_rpm, target_rpm, 16.0 * delta)
	else:
		# Marchas para frente (1ª a 6ª)
		var wheel_rpm = 0.0
		if wheel_rl and wheel_rr:
			wheel_rpm = (abs(wheel_rl.get_rpm()) + abs(wheel_rr.get_rpm())) * 0.5
		
		var mechanical_rpm = wheel_rpm * abs(gear_ratio) * data.final_drive
		
		if current_speed_kmh < 20.0 and current_gear_idx == 2:
			# Arrancada em 1ª marcha: o motor sobe giro com aceleração (simulação de embreagem esportiva)
			var launch_rpm = lerp(data.idle_rpm, data.redline_rpm * 0.6, throttle_in)
			var target_rpm = max(mechanical_rpm, launch_rpm)
			current_rpm = lerp(current_rpm, clamp(target_rpm, data.idle_rpm, data.redline_rpm), 14.0 * delta)
		else:
			# Carro em velocidade engatado: RPM sincronizado com a transmissão
			var target_rpm = max(mechanical_rpm, data.idle_rpm)
			var lerp_spd = 20.0 if throttle_in > 0.1 else 10.0
			current_rpm = lerp(current_rpm, clamp(target_rpm, data.idle_rpm, data.redline_rpm), lerp_spd * delta)
		
		# --- TROCAS AUTOMÁTICAS DE MARCHA ---
		if is_automatic and not is_shifting:
			# Subir marcha (Upshift) aos 88% do limitador (~7200 RPM)
			if current_rpm > data.redline_rpm * 0.88 and current_gear_idx < data.gear_ratios.size() - 1:
				perform_gear_shift(current_gear_idx + 1)
			# Reduzir marcha (Downshift) quando a rotação cai abaixo de 3000 RPM
			elif current_rpm < data.idle_rpm * 2.4 and current_gear_idx > 2:
				perform_gear_shift(current_gear_idx - 1)

func perform_gear_shift(new_gear: int) -> void:
	current_gear_idx = new_gear
	is_shifting = true
	shift_timer = SHIFT_DURATION
	current_rpm *= 0.78

func reset_vehicle_orientation() -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_transform.origin += Vector3(0, 1.5, 0)
	rotation.x = 0.0
	rotation.z = 0.0

func update_telemetry() -> void:
	var display_gear = current_gear_idx - 1
	if current_gear_idx == 0:
		display_gear = -1
	elif current_gear_idx == 1:
		display_gear = 0
	
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
