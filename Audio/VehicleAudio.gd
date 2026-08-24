extends Node
class_name VehicleAudio

@export var vehicle: VehicleBase

# Geradores de áudio sintetizado para evitar dependência de arquivos externos pesados
var engine_player: AudioStreamPlayer3D
var tire_squeal_player: AudioStreamPlayer3D

func _ready() -> void:
	if not vehicle:
		vehicle = get_parent() as VehicleBase
	
	setup_audio_generators()

func setup_audio_generators() -> void:
	# Áudio do Motor
	engine_player = AudioStreamPlayer3D.new()
	engine_player.name = "EngineAudio"
	engine_player.bus = "Master"
	engine_player.max_distance = 60.0
	engine_player.unit_size = 10.0
	add_child(engine_player)
	
	var engine_gen = AudioStreamGenerator.new()
	engine_gen.mix_rate = 22050.0
	engine_gen.buffer_length = 0.1
	engine_player.stream = engine_gen
	engine_player.play()
	
	# Áudio do Pneu (Derrapagem / Skid)
	tire_squeal_player = AudioStreamPlayer3D.new()
	tire_squeal_player.name = "TireSquealAudio"
	tire_squeal_player.bus = "Master"
	tire_squeal_player.max_distance = 45.0
	tire_squeal_player.unit_size = 8.0
	add_child(tire_squeal_player)
	
	var tire_gen = AudioStreamGenerator.new()
	tire_gen.mix_rate = 22050.0
	tire_gen.buffer_length = 0.1
	tire_squeal_player.stream = tire_gen
	tire_squeal_player.play()

func _physics_process(delta: float) -> void:
	if not vehicle:
		return
	
	# Ajuste dinâmico de pitch e volume baseado em RPM e Carga
	var rpm_norm = clamp(vehicle.current_rpm / (vehicle.data.redline_rpm if vehicle.data else 7500.0), 0.1, 1.0)
	engine_player.pitch_scale = lerp(0.6, 2.2, rpm_norm)
	
	# Simulação de perda de aderência para som de pneu
	var max_slip = 1.0
	if vehicle.wheel_rl and vehicle.wheel_rr:
		max_slip = min(vehicle.wheel_rl.get_skidinfo(), vehicle.wheel_rr.get_skidinfo())
	
	var is_skidding = max_slip < 0.75 or (vehicle.brake > 10.0 and vehicle.current_speed_kmh > 30.0)
	var target_volume_db = -80.0
	if is_skidding:
		var skid_intensity = clamp((0.75 - max_slip) / 0.75, 0.0, 1.0)
		target_volume_db = lerp(-20.0, 0.0, skid_intensity)
	
	tire_squeal_player.volume_db = lerp(tire_squeal_player.volume_db, target_volume_db, 15.0 * delta)
