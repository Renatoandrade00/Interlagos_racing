extends Camera3D
class_name ChaseCamera

## Nó-alvo que a câmera deve seguir (o carro do jogador)
@export var target_node: Node3D

## Distância horizontal para trás do carro (em metros)
@export var distance: float = 6.0
## Altura acima do carro (em metros)
@export var height: float = 2.2
## Velocidade de suavização da posição (quanto maior, mais responsiva)
@export var smooth_speed: float = 8.0
## Distância do ponto de mira à frente do carro
@export var look_ahead_dist: float = 6.0
## FOV base (parado)
@export var fov_base: float = 68.0
## FOV máximo (velocidade máxima)
@export var fov_max: float = 82.0

## Velocidade de suavização da rotação
@export var rotation_smooth: float = 6.0

# Variáveis internas de interpolação
var _smooth_position: Vector3
var _initialized: bool = false

func _ready() -> void:
	# Garantir que a câmera processa em _physics_process
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not target_node or not is_instance_valid(target_node):
		return
	
	var target_transform = target_node.global_transform
	var car_pos = target_transform.origin
	
	# Direção "para frente" do carro no plano XZ (basis.z negativo = frente no Godot)
	var forward_vec = -target_transform.basis.z.normalized()
	
	# A câmera fica ATRÁS do carro: posição do carro MENOS forward * distância
	var desired_pos = car_pos - (forward_vec * distance) + Vector3(0, height, 0)
	
	# Inicializar posição suave na primeira frame para evitar salto
	if not _initialized:
		_smooth_position = desired_pos
		global_transform.origin = desired_pos
		_initialized = true
	
	# Interpolação suave da posição (lerp com delta)
	_smooth_position = _smooth_position.lerp(desired_pos, smooth_speed * delta)
	global_transform.origin = _smooth_position
	
	# Ponto de mira à frente do carro (ligeiramente acima do centro de massa)
	var look_target = car_pos + (forward_vec * look_ahead_dist) + Vector3(0, 0.6, 0)
	look_at(look_target, Vector3.UP)
	
	# FOV dinâmico proporcional à velocidade — dá sensação de velocidade como GT4
	if target_node is VehicleBody3D:
		var speed_kmh = target_node.linear_velocity.length() * 3.6
		var fov_factor = clamp(speed_kmh / 250.0, 0.0, 1.0)
		fov = lerp(fov_base, fov_max, fov_factor)
