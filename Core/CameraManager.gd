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

# Configurações de offset para cada visão
const OFFSETS = {
	CameraView.CHASE: { "distance": 5.2, "height": 1.9, "look_ahead": 4.0, "fov_base": 70.0 },
	CameraView.HOOD: { "distance": -0.4, "height": 0.95, "look_ahead": 12.0, "fov_base": 78.0 },
	CameraView.BUMPER: { "distance": -1.8, "height": 0.45, "look_ahead": 15.0, "fov_base": 85.0 }
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
	
	match current_view:
		CameraView.CHASE:
			print("[CAMERA] Visão: Perseguição (Chase)")
		CameraView.HOOD:
			print("[CAMERA] Visão: Capô (Hood)")
		CameraView.BUMPER:
			print("[CAMERA] Visão: Parachoque / Asfalto (Bumper)")
