extends Node3D
class_name InterlagosSlice

@onready var player_car: VehicleBase = $VehiclePrototype
@onready var rival_car: VehicleBase = $VehicleRivalAI
@onready var chase_camera: ChaseCamera = $ChaseCamera
@onready var hud: RacingHUD = $RacingHUD
@onready var lap_manager: LapCheckpointsManager = $LapManager
@onready var telemetry_overlay: TelemetryOverlay = $TelemetryOverlay
@onready var minimap_overlay: MinimapOverlay = $MinimapOverlay

func _ready() -> void:
	if chase_camera and player_car:
		chase_camera.target_node = player_car
	if hud and player_car:
		hud.vehicle = player_car
	if telemetry_overlay and player_car:
		telemetry_overlay.vehicle = player_car
	if minimap_overlay:
		if player_car:
			minimap_overlay.player_node = player_car
		if rival_car:
			minimap_overlay.ai_nodes = [rival_car]
	
	if lap_manager:
		if player_car:
			lap_manager.register_car(player_car)
		if rival_car:
			lap_manager.register_car(rival_car)
		lap_manager.lap_completed.connect(_on_lap_completed)

func _on_lap_completed(car: Node, lap_num: int, lap_time: float) -> void:
	if car == player_car and hud:
		var minutes = int(lap_time / 60.0)
		var seconds = fmod(lap_time, 60.0)
		print("[RACE] Player completed Lap %d - Time: %02d:%05.2f" % [lap_num, minutes, seconds])
