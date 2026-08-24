extends Control
class_name PauseMenu

signal resume_requested
signal restart_requested
signal exit_to_menu_requested

@onready var btn_resume: Button = $Panel/VBoxContainer/BtnResume
@onready var btn_restart: Button = $Panel/VBoxContainer/BtnRestart
@onready var btn_menu: Button = $Panel/VBoxContainer/BtnMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	btn_resume.pressed.connect(_on_resume_pressed)
	btn_restart.pressed.connect(_on_restart_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		toggle_pause()

func toggle_pause() -> void:
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused:
		btn_resume.grab_focus()

func _on_resume_pressed() -> void:
	toggle_pause()
	resume_requested.emit()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	restart_requested.emit()
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	exit_to_menu_requested.emit()
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
