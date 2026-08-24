extends Node
class_name AIDriverController

@export var vehicle: VehicleBase
@export var waypoints: Array[Vector3] = []
@export var target_speed_kmh: float = 140.0
@export var waypoint_reach_dist: float = 6.0

var current_wp_idx: int = 0

func _ready() -> void:
	if vehicle:
		vehicle.is_player_controlled = false

func _physics_process(delta: float) -> void:
	if not vehicle or waypoints.is_empty():
		return
	
	var target_pos = waypoints[current_wp_idx]
	var car_pos = vehicle.global_transform.origin
	var dist = car_pos.distance_to(target_pos)
	
	if dist < waypoint_reach_dist:
		current_wp_idx = (current_wp_idx + 1) % waypoints.size()
		target_pos = waypoints[current_wp_idx]
	
	# Vetor local de direção até o próximo waypoint
	var forward = -vehicle.global_transform.basis.z.normalized()
	var to_target = (target_pos - car_pos).normalized()
	
	var cross_prod = forward.cross(to_target)
	var steer_amount = clamp(cross_prod.y * 2.5, -1.0, 1.0)
	
	var max_steer_rad = deg_to_rad(vehicle.data.steer_limit_deg) if vehicle.data else deg_to_rad(30.0)
	vehicle.steering = move_toward(vehicle.steering, steer_amount * max_steer_rad, 4.0 * delta)
	
	# Força negativa empurra para FRENTE (-Z) no Godot
	var spd = vehicle.current_speed_kmh
	var max_f = vehicle.data.max_engine_force if vehicle.data else 2600.0
	if spd < target_speed_kmh:
		vehicle.engine_force = -max_f
		vehicle.brake = 0.0
	else:
		vehicle.engine_force = 0.0
		vehicle.brake = 25.0
