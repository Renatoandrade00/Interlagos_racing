extends Resource
class_name VehicleData

@export_group("Geral")
@export var id: String = "car_proto_rwd"
@export var display_name: String = "Apex GT Prototype"
@export var category: String = "Sports Coupe"

@export_group("Chassi & Massa")
@export var mass: float = 1350.0 # kg
@export var center_of_mass_offset: Vector3 = Vector3(0.0, -0.2, 0.0)

@export_group("Motor & Transmissão")
@export var max_engine_force: float = 380.0 # N
@export var max_brake_force: float = 60.0 # N
@export var redline_rpm: float = 7500.0
@export var idle_rpm: float = 900.0
@export var gear_ratios: Array[float] = [-3.4, 0.0, 3.8, 2.3, 1.6, 1.2, 0.9] # R, N, 1..5
@export var final_drive: float = 3.9

@export_group("Suspensão")
@export var suspension_travel: float = 0.2
@export var suspension_stiffness: float = 45.0
@export var suspension_damping: float = 4.5

@export_group("Pneus & Dinâmica (Simcade)")
@export var tire_friction_slip: float = 2.4 # Grip lateral/longitudinal base
@export var steer_limit_deg: float = 32.0
@export var steer_speed: float = 4.5
