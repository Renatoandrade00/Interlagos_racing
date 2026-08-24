extends Camera3D
class_name ChaseCamera

## Nó-alvo que a câmera deve seguir (o carro do jogador)
@export var target_node: Node3D

## Distância horizontal para trás do carro (em metros)
@export var distance: float = 6.2
## Altura acima do carro (em metros)
@export var height: float = 2.4
## Velocidade de suavização da posição
@export var smooth_speed: float = 10.0
## Distância do ponto de mira à frente do carro
@export var look_ahead_dist: float = 8.0
## FOV base
@export var fov_base: float = 68.0
## FOV máximo
@export var fov_max: float = 82.0

var _smooth_position: Vector3
var _initialized: bool = false

func _ready() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not target_node or not is_instance_valid(target_node):
		return
	
	var target_transform = target_node.global_transform
	var car_pos = target_transform.origin
	
	# Vetor "frente" do carro no espaço mundial (no Godot, -basis.z é a frente)
	var forward_vec = -target_transform.basis.z.normalized()
	
	# Posição da câmera: ATRÁS do carro (subtrai a frente multiplicada pela distância)
	var desired_pos = car_pos - (forward_vec * distance) + Vector3(0, height, 0)
	
	if not _initialized:
		_smooth_position = desired_pos
		global_transform.origin = desired_pos
		_initialized = true
	
	# Interpolação suave
	_smooth_position = _smooth_position.lerp(desired_pos, smooth_speed * delta)
	global_transform.origin = _smooth_position
	
	# Mira à frente do carro ao longo da pista
	var look_target = car_pos + (forward_vec * look_ahead_dist) + Vector3(0, 0.8, 0)
	look_at(look_target, Vector3.UP)
	
	# FOV dinâmico com a velocidade
	if target_node is VehicleBody3D:
		var speed_kmh = target_node.linear_velocity.length() * 3.6
		var fov_factor = clamp(speed_kmh / 250.0, 0.0, 1.0)
		fov = lerp(fov_base, fov_max, fov_factor)
