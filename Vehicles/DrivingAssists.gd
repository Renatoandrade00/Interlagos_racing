extends Node
class_name DrivingAssists

@export var vehicle: VehicleBase
@export var abs_enabled: bool = true
@export var tcs_enabled: bool = true
@export var esp_enabled: bool = true

func _physics_process(delta: float) -> void:
	if not vehicle or not vehicle.is_player_controlled:
		return
	
	apply_abs()
	apply_tcs()
	apply_esp(delta)

func apply_abs() -> void:
	if not abs_enabled or vehicle.brake <= 0.01:
		return
	
	# Se as rodas estiverem travando (skid info muito baixo em frenagem), pulsa o freio
	for w in [vehicle.wheel_fl, vehicle.wheel_fr, vehicle.wheel_rl, vehicle.wheel_rr]:
		if w and w.get_skidinfo() < 0.25 and vehicle.current_speed_kmh > 15.0:
			vehicle.brake *= 0.65
			break

func apply_tcs() -> void:
	if not tcs_enabled or vehicle.engine_force <= 0.01:
		return
	
	# Se as rodas de tração traseiras estiverem patinando em aceleração, reduz o torque
	var rear_skid = 1.0
	if vehicle.wheel_rl and vehicle.wheel_rr:
		rear_skid = min(vehicle.wheel_rl.get_skidinfo(), vehicle.wheel_rr.get_skidinfo())
	
	if rear_skid < 0.45:
		vehicle.engine_force *= 0.55

func apply_esp(delta: float) -> void:
	if not esp_enabled or vehicle.current_speed_kmh < 30.0:
		return
	
	# Anti-oversteer (sobreesterço): se a velocidade angular Y for muito maior que a direção pretendida
	var angular_y = vehicle.angular_velocity.y
	var expected_yaw_rate = -vehicle.steering * (vehicle.current_speed_kmh / 45.0)
	var yaw_diff = angular_y - expected_yaw_rate
	
	if abs(yaw_diff) > 0.8:
		# Aplica leve torque contrário estabilizador
		vehicle.apply_torque(Vector3(0, -yaw_diff * 400.0 * delta, 0))
