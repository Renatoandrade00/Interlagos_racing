extends Camera3D
class_name ChaseCamera

@export var target_node: Node3D
@export var distance: float = 5.2
@export var height: float = 1.9
@export var smooth_speed: float = 9.0
@export var look_ahead_dist: float = 4.0
@export var fov_base: float = 70.0
@export var fov_max: float = 85.0

func _physics_process(delta: float) -> void:
	if not target_node:
		return
	
	# Posição alvo atrás do veículo considerando a rotação Y do carro
	var target_transform = target_node.global_transform
	var forward_vec = -target_transform.basis.z.normalized()
	
	var desired_pos = target_transform.origin - (forward_vec * distance) + Vector3(0, height, 0)
	global_transform.origin = global_transform.origin.lerp(desired_pos, smooth_speed * delta)
	
	# Ponto de mira à frente do veículo
	var look_target = target_transform.origin + (forward_vec * look_ahead_dist) + Vector3(0, 0.4, 0)
	look_at(look_target, Vector3.UP)
	
	# FOV dinâmico conforme velocidade
	if target_node is VehicleBody3D:
		var speed_kmh = target_node.linear_velocity.length() * 3.6
		var fov_factor = clamp(speed_kmh / 240.0, 0.0, 1.0)
		fov = lerp(fov_base, fov_max, fov_factor)
