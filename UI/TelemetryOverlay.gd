extends Control
class_name TelemetryOverlay

@export var vehicle: VehicleBase

@onready var panel: Panel = $Panel
@onready var lbl_speed: Label = $Panel/VBox/LblSpeed
@onready var lbl_rpm: Label = $Panel/VBox/LblRPM
@onready var lbl_gear: Label = $Panel/VBox/LblGear
@onready var lbl_steering: Label = $Panel/VBox/LblSteering
@onready var lbl_g_forces: Label = $Panel/VBox/LblGForces
@onready var lbl_tires: Label = $Panel/VBox/LblTires

var last_velocity: Vector3 = Vector3.ZERO
var current_g_force: Vector3 = Vector3.ZERO

func _ready() -> void:
	visible = false # Alterna com a tecla F3 ou T

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and (event.keycode == KEY_F3 or event.keycode == KEY_T):
		visible = !visible

func _physics_process(delta: float) -> void:
	if not visible or not vehicle:
		return
	
	# Cálculo de aceleração lateral e longitudinal (Forças G)
	var current_vel = vehicle.linear_velocity
	var accel = (current_vel - last_velocity) / max(delta, 0.001)
	last_velocity = current_vel
	
	# Converter para coordenadas locais do carro e dividir por 9.81 (1G)
	var local_accel = vehicle.global_transform.basis.inverse() * accel
	current_g_force = local_accel / 9.81
	
	# Atualizar dados visuais
	var t = vehicle.telemetry
	lbl_speed.text = "Velocidade: %5.1f km/h" % t.get("speed_kmh", 0.0)
	lbl_rpm.text = "RPM Motor: %5.0f rpm" % t.get("rpm", 0.0)
	lbl_gear.text = "Marcha: %d" % t.get("gear", 0)
	lbl_steering.text = "Esterço: %5.1f°" % t.get("steering", 0.0)
	lbl_g_forces.text = "Força G (Lat/Long): Lat %+.2f G | Long %+.2f G" % [-current_g_force.x, -current_g_force.z]
	
	lbl_tires.text = "Aderência Pneus (FL/FR/RL/RR):\nFL: %.2f | FR: %.2f\nRL: %.2f | RR: %.2f" % [
		t.get("slip_fl", 1.0),
		t.get("slip_fr", 1.0),
		t.get("slip_rl", 1.0),
		t.get("slip_rr", 1.0)
	]
