extends Node
class_name CameraManager

enum CameraView {
	CHASE = 0,
	HOOD = 1,
	BUMPER = 2
}

@export var current_view: CameraView = CameraView.CHASE
@export var chase_camera: ChaseCamera
@export var target_vehicle: VehicleBase

# Configurações para cada ponto de vista
#   CHASE:  câmera de perseguição clássica atrás e acima do carro (estilo GT4)
#   HOOD:   câmera rente ao capô, dentro do carro
#   BUMPER: câmera no nível do asfalto, parachoque dianteiro
const OFFSETS = {
	CameraView.CHASE:  { "distance": 6.0,  "height": 2.2,  "look_ahead": 6.0,  "fov_base": 68.0 },
	CameraView.HOOD:   { "distance": -0.3, "height": 1.0,  "look_ahead": 14.0, "fov_base": 78.0 },
	CameraView.BUMPER: { "distance": -1.6, "height": 0.5,  "look_ahead": 18.0, "fov_base": 84.0 }
}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_camera"):
		cycle_camera_view()

func cycle_camera_view() -> void:
	current_view = ((current_view + 1) % 3) as CameraView
	apply_camera_view()

func apply_camera_view() -> void:
	if not chase_camera:
		return
	
	var cfg = OFFSETS[current_view]
	chase_camera.distance = cfg["distance"]
	chase_camera.height = cfg["height"]
	chase_camera.look_ahead_dist = cfg["look_ahead"]
	chase_camera.fov_base = cfg["fov_base"]
	# Resetar interpolação para evitar salto ao trocar de câmera
	chase_camera._initialized = false
