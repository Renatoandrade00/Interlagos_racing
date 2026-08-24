extends Control
class_name CarSelectionMenu

signal car_selected(car_data: VehicleData)

@onready var car_name_label: Label = $InfoPanel/CarNameLabel
@onready var car_category_label: Label = $InfoPanel/CategoryLabel
@onready var mass_val: Label = $InfoPanel/SpecsGrid/MassValue
@onready var power_val: Label = $InfoPanel/SpecsGrid/PowerValue
@onready var drivetrain_val: Label = $InfoPanel/SpecsGrid/DrivetrainValue
@onready var btn_prev: Button = $NavPanel/BtnPrev
@onready var btn_next: Button = $NavPanel/BtnNext
@onready var btn_select: Button = $NavPanel/BtnSelect
@onready var btn_back: Button = $BtnBack

var available_cars: Array[VehicleData] = []
var current_car_idx: int = 0

func _ready() -> void:
	load_cars()
	update_car_display()
	
	btn_prev.pressed.connect(_on_prev_pressed)
	btn_next.pressed.connect(_on_next_pressed)
	btn_select.pressed.connect(_on_select_pressed)
	btn_back.pressed.connect(_on_back_pressed)

func load_cars() -> void:
	available_cars.append(preload("res://Vehicles/car_proto_rwd.tres"))
	available_cars.append(preload("res://Vehicles/car_ai_rival.tres"))

func update_car_display() -> void:
	if available_cars.is_empty():
		return
	
	var car = available_cars[current_car_idx]
	car_name_label.text = car.display_name
	car_category_label.text = car.category
	mass_val.text = "%d kg" % int(car.mass)
	power_val.text = "%d N (Torque Base)" % int(car.max_engine_force)
	drivetrain_val.text = "RWD (Tração Traseira)"

func _on_prev_pressed() -> void:
	current_car_idx = (current_car_idx - 1 + available_cars.size()) % available_cars.size()
	update_car_display()

func _on_next_pressed() -> void:
	current_car_idx = (current_car_idx + 1) % available_cars.size()
	update_car_display()

func _on_select_pressed() -> void:
	var car = available_cars[current_car_idx]
	car_selected.emit(car)
	get_tree().change_scene_to_file("res://Tracks/Interlagos/InterlagosVerticalSlice.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
