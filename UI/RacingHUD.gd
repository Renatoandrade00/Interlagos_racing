extends Control
class_name RacingHUD

@export var vehicle: VehicleBase

@onready var speed_label: Label = $Cluster/SpeedNumber
@onready var gear_label: Label = $Cluster/GearCircle/GearLabel
@onready var rpm_bar: ProgressBar = $Cluster/RPMBar
@onready var rpm_number: Label = $Cluster/RPMNumber
@onready var time_label: Label = $TopHeader/TimeContainer/TimeValue
@onready var lap_label: Label = $TopHeader/LapContainer/LapValue

var current_race_time: float = 0.0

func _process(delta: float) -> void:
	current_race_time += delta
	var minutes = int(current_race_time / 60.0)
	var seconds = fmod(current_race_time, 60.0)
	if time_label:
		time_label.text = "%02d:%05.2f" % [minutes, seconds]
	
	if vehicle and is_instance_valid(vehicle):
		var spd = int(vehicle.current_speed_kmh)
		if speed_label:
			speed_label.text = "%d" % spd
		
		var gear = vehicle.current_gear_idx
		if gear_label:
			if gear == 0:
				gear_label.text = "R"
			elif gear == 1:
				gear_label.text = "N"
			else:
				gear_label.text = str(gear - 1)
		
		if rpm_bar:
			rpm_bar.max_value = vehicle.data.redline_rpm if vehicle.data else 8000.0
			rpm_bar.value = vehicle.current_rpm
		
		if rpm_number:
			rpm_number.text = "%d RPM" % int(vehicle.current_rpm)
