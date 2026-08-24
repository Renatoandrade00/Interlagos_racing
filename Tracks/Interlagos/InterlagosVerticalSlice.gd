extends Node3D
class_name InterlagosSlice

@onready var player_car: VehicleBase = $VehiclePrototype
@onready var rival_car: VehicleBase = $VehicleRivalAI
@onready var chase_camera: ChaseCamera = $ChaseCamera
@onready var camera_manager: CameraManager = $CameraManager
@onready var hud: RacingHUD = $RacingHUD
@onready var lap_manager: LapCheckpointsManager = $LapManager
@onready var telemetry_overlay: TelemetryOverlay = $TelemetryOverlay
@onready var minimap_overlay: MinimapOverlay = $MinimapOverlay
@onready var results_screen: RaceResultsScreen = $RaceResultsScreen
@onready var countdown_overlay: CountdownController = $CountdownController
@onready var track_builder: InterlagosTrackBuilder = $TrackBuilder
@onready var ai_controller: AIDriverController = $AIController

var total_race_laps: int = 3
var race_start_timestamp: float = 0.0
var race_started: bool = false

func _ready() -> void:
	# Carregar dados do carro escolhido
	if player_car:
		player_car.data = GameManager.get_selected_vehicle()
		player_car.apply_vehicle_data()
		player_car.set_physics_process(false)
	
	if rival_car:
		rival_car.set_physics_process(false)
	
	# Configurar waypoints da IA com todo o traçado do circuito
	if ai_controller and track_builder:
		ai_controller.waypoints = track_builder.get_circuit_waypoints()
	
	# --- CÂMERA: conectar ao carro do jogador ---
	if chase_camera and player_car:
		chase_camera.target_node = player_car
		var car_pos = player_car.global_transform.origin
		var forward = -player_car.global_transform.basis.z.normalized()
		chase_camera.global_transform.origin = car_pos - (forward * 6.2) + Vector3(0, 2.4, 0)
		chase_camera.look_at(car_pos + (forward * 8.0) + Vector3(0, 0.8, 0), Vector3.UP)
	
	if camera_manager and chase_camera and player_car:
		camera_manager.chase_camera = chase_camera
		camera_manager.target_vehicle = player_car
	
	if hud and player_car:
		hud.vehicle = player_car
	if telemetry_overlay and player_car:
		telemetry_overlay.vehicle = player_car
	if minimap_overlay:
		if player_car:
			minimap_overlay.player_node = player_car
		if rival_car:
			minimap_overlay.ai_nodes = [rival_car]
	
	if countdown_overlay:
		countdown_overlay.countdown_finished.connect(_on_race_start)
	
	if lap_manager:
		if player_car:
			lap_manager.register_car(player_car)
		if rival_car:
			lap_manager.register_car(rival_car)
		lap_manager.lap_completed.connect(_on_lap_completed)

func _on_race_start() -> void:
	race_started = true
	race_start_timestamp = Time.get_ticks_msec() / 1000.0
	if player_car:
		player_car.set_physics_process(true)
	if rival_car:
		rival_car.set_physics_process(true)
	print("[RACE] Corrida completa de Interlagos iniciada!")

func _on_lap_completed(car: Node, lap_num: int, lap_time: float) -> void:
	if car == player_car:
		var minutes = int(lap_time / 60.0)
		var seconds = fmod(lap_time, 60.0)
		print("[RACE] Player completed Lap %d - Time: %02d:%05.2f" % [lap_num, minutes, seconds])
		
		if hud:
			var lap_lbl = hud.get_node_or_null("TopHeader/LapContainer/LapValue") as Label
			if lap_lbl:
				lap_lbl.text = "LAP %d/%d" % [min(lap_num + 1, total_race_laps), total_race_laps]
		
		if lap_num >= total_race_laps and results_screen:
			var now = Time.get_ticks_msec() / 1000.0
			var total_time = now - race_start_timestamp
			var best_lap = lap_manager.car_progress[player_car].get("best_lap_time", lap_time)
			results_screen.show_results(1, best_lap, total_time)
