extends Control
class_name RacingHUD

@export var vehicle: VehicleBase

@onready var speed_label: Label = $Panel/SpeedLabel
@onready var gear_label: Label = $Panel/GearLabel
@onready var rpm_bar: ProgressBar = $Panel/RPMBar
@onready var time_label: Label = $TopPanel/TimeLabel
@onready var lap_label: Label = $TopPanel/LapLabel

var current_race_time: float = 0.0

func _process(delta: float) -> void:
	current_race_time += delta
	var minutes = int(current_race_time / 60.0)
	var seconds = fmod(current_race_time, 60.0)
	time_label.text = "TIME: %02d:%05.2f" % [minutes, seconds]
	
	if vehicle and is_instance_valid(vehicle):
		var spd = int(vehicle.current_speed_kmh)
		speed_label.text = "%3d KM/H" % spd
		
		var gear = vehicle.current_gear_idx
		if gear == 0:
			gear_label.text = "R"
		elif gear == 1:
			gear_label.text = "N"
		else:
			gear_label.text = str(gear - 1)
		
		rpm_bar.max_value = vehicle.data.redline_rpm if vehicle.data else 8000.0
		rpm_bar.value = vehicle.current_rpm
