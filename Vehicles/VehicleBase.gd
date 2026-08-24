extends VehicleBody3D
class_name VehicleBase

@export var data: VehicleData
@export var is_player_controlled: bool = true

# Nós das rodas
@onready var wheel_fl: VehicleWheel3D = $WheelFL
@onready var wheel_fr: VehicleWheel3D = $WheelFR
@onready var wheel_rl: VehicleWheel3D = $WheelRL
@onready var wheel_rr: VehicleWheel3D = $WheelRR

# Estado dinâmico do veículo
var current_gear_idx: int = 2 # 0: R, 1: N, 2: 1ª, 3: 2ª...
var current_rpm: float = 900.0
var current_speed_kmh: float = 0.0
var current_steer_target: float = 0.0
var is_automatic: bool = true

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
			w.damping_relaxation = data.suspension_damping * 1.2
			w.wheel_friction_slip = data.tire_friction_slip

func _physics_process(delta: float) -> void:
	# Velocidade em km/h baseada no vetor de velocidade linear
	var speed_ms = linear_velocity.length()
	current_speed_kmh = speed_ms * 3.6
	
	if is_player_controlled:
		process_player_input(delta)
	
	process_powertrain(delta)
	update_telemetry()

func process_player_input(delta: float) -> void:
	# Aceleração e Frenagem
	var throttle_val = Input.get_action_raw_strength("throttle")
	var brake_val = Input.get_action_raw_strength("brake")
	var handbrake_val = 1.0 if Input.is_action_pressed("handbrake") else 0.0
	
	# Direção com suavização e sensibilidade a velocidade
	var steer_input = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	
	# Em alta velocidade, reduz ligeiramente o ângulo máximo para estabilidade estilo GT4
	var speed_factor = clamp(1.0 - (current_speed_kmh / 280.0) * 0.45, 0.4, 1.0)
	var max_steer_rad = deg_to_rad(data.steer_limit_deg * speed_factor)
	current_steer_target = steer_input * max_steer_rad
	
	steering = move_toward(steering, current_steer_target, data.steer_speed * delta)
	
	# Transmissão de força (RWD - Tração traseira com freio nas 4 rodas)
	var drive_force = throttle_val * data.max_engine_force
	engine_force = drive_force
	
	# Freio com distribuição 60% frente / 40% trás
	var base_brake = brake_val * data.max_brake_force
	brake = base_brake + (handbrake_val * data.max_brake_force * 0.8)
	
	# Reset do carro se capotar
	if Input.is_action_just_pressed("reset_car"):
		reset_vehicle_orientation()

func process_powertrain(delta: float) -> void:
	# Cálculo simplificado de RPM baseado em velocidade da roda / marcha
	var wheel_speed = 0.0
	if wheel_rl and wheel_rr:
		wheel_speed = (wheel_rl.get_rpm() + wheel_rr.get_rpm()) * 0.5
	
	var gear_ratio = data.gear_ratios[current_gear_idx]
	if abs(gear_ratio) > 0.01:
		var target_rpm = abs(wheel_speed * gear_ratio * data.final_drive)
		current_rpm = clamp(target_rpm, data.idle_rpm, data.redline_rpm)
	else:
		current_rpm = data.idle_rpm
	
	# Câmbio automático simples
	if is_automatic and current_gear_idx >= 2:
		if current_rpm > data.redline_rpm * 0.88 and current_gear_idx < data.gear_ratios.size() - 1:
			current_gear_idx += 1
		elif current_rpm < data.idle_rpm * 1.8 and current_gear_idx > 2:
			current_gear_idx -= 1

func reset_vehicle_orientation() -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_transform.origin += Vector3(0, 1.5, 0)
	rotation.x = 0.0
	rotation.z = 0.0

func update_telemetry() -> void:
	telemetry = {
		"speed_kmh": current_speed_kmh,
		"rpm": current_rpm,
		"gear": current_gear_idx - 1, # 0=N, 1=1ª...
		"steering": rad_to_deg(steering),
		"slip_fl": wheel_fl.get_skidinfo() if wheel_fl else 1.0,
		"slip_fr": wheel_fr.get_skidinfo() if wheel_fr else 1.0,
		"slip_rl": wheel_rl.get_skidinfo() if wheel_rl else 1.0,
		"slip_rr": wheel_rr.get_skidinfo() if wheel_rr else 1.0
	}
