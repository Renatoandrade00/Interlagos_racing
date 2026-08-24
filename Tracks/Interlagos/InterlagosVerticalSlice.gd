extends Node3D
class_name InterlagosSlice

@onready var player_car: VehicleBase = $VehiclePrototype
@onready var chase_camera: ChaseCamera = $ChaseCamera
@onready var hud: RacingHUD = $RacingHUD

func _ready() -> void:
	if chase_camera and player_car:
		chase_camera.target_node = player_car
	if hud and player_car:
		hud.vehicle = player_car
