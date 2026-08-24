extends Control
class_name RaceResultsScreen

signal retry_requested
signal return_to_menu_requested

@onready var lbl_finish_pos: Label = $Panel/LblFinishPosition
@onready var lbl_best_lap: Label = $Panel/GridTimes/LblBestLapVal
@onready var lbl_total_time: Label = $Panel/GridTimes/LblTotalTimeVal
@onready var btn_retry: Button = $Panel/HBoxButtons/BtnRetry
@onready var btn_menu: Button = $Panel/HBoxButtons/BtnMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	btn_retry.pressed.connect(_on_retry_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)

func show_results(position: int, best_lap_sec: float, total_time_sec: float) -> void:
	get_tree().paused = true
	visible = true
	
	if position == 1:
		lbl_finish_pos.text = "🏆 1º LUGAR — VITÓRIA!"
		lbl_finish_pos.set("theme_override_colors/font_color", Color(1.0, 0.85, 0.2))
	else:
		lbl_finish_pos.text = "🏁 %dº LUGAR" % position
		lbl_finish_pos.set("theme_override_colors/font_color", Color(0.9, 0.9, 0.9))
	
	lbl_best_lap.text = format_time(best_lap_sec)
	lbl_total_time.text = format_time(total_time_sec)
	btn_retry.grab_focus()

func format_time(time_sec: float) -> String:
	if time_sec <= 0.0 or time_sec >= 99999.0:
		return "--:--.--"
	var minutes = int(time_sec / 60.0)
	var seconds = fmod(time_sec, 60.0)
	return "%02d:%05.2f" % [minutes, seconds]

func _on_retry_pressed() -> void:
	get_tree().paused = false
	retry_requested.emit()
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	return_to_menu_requested.emit()
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
