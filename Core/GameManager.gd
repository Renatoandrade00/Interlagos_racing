extends Node
class_name GameManager

static var selected_vehicle_data: VehicleData

static func set_selected_vehicle(data: VehicleData) -> void:
	selected_vehicle_data = data

static func get_selected_vehicle() -> VehicleData:
	if not selected_vehicle_data:
		selected_vehicle_data = preload("res://Vehicles/car_proto_rwd.tres")
	return selected_vehicle_data
