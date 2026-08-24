extends Control
class_name MainMenu

signal start_game_requested
signal exit_game_requested

@onready var btn_quick_race: Button = $VBoxContainer/BtnQuickRace
@onready var btn_time_trial: Button = $VBoxContainer/BtnTimeTrial
@onready var btn_settings: Button = $VBoxContainer/BtnSettings
@onready var btn_quit: Button = $VBoxContainer/BtnQuit
@onready var settings_panel: Panel = $SettingsPanel

# Configurações gráficas e áudio
@onready var opt_resolution: OptionButton = $SettingsPanel/VBoxSettings/HBoxRes/OptResolution
@onready var opt_graphics_preset: OptionButton = $SettingsPanel/VBoxSettings/HBoxPreset/OptPreset
@onready var slider_volume: HSlider = $SettingsPanel/VBoxSettings/HBoxVol/SliderVolume
@onready var btn_close_settings: Button = $SettingsPanel/BtnCloseSettings

func _ready() -> void:
	btn_quick_race.pressed.connect(_on_quick_race_pressed)
	btn_time_trial.pressed.connect(_on_time_trial_pressed)
	btn_settings.pressed.connect(_on_settings_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)
	btn_close_settings.pressed.connect(func(): settings_panel.visible = false)
	
	setup_settings_options()

func setup_settings_options() -> void:
	opt_resolution.add_item("1280x720 (Nativo UHD 620)")
	opt_resolution.add_item("1920x1080 (Full HD)")
	opt_resolution.add_item("960x540 (Performance Ultra)")
	
	opt_graphics_preset.add_item("Low (Recomendado UHD 620)")
	opt_graphics_preset.add_item("Medium")
	opt_graphics_preset.add_item("High")
	
	opt_resolution.item_selected.connect(_on_resolution_selected)
	opt_graphics_preset.item_selected.connect(_on_preset_selected)
	slider_volume.value_changed.connect(_on_volume_changed)

func _on_quick_race_pressed() -> void:
	get_tree().change_scene_to_file("res://Tracks/Interlagos/InterlagosVerticalSlice.tscn")

func _on_time_trial_pressed() -> void:
	get_tree().change_scene_to_file("res://Tracks/Interlagos/InterlagosVerticalSlice.tscn")

func _on_settings_pressed() -> void:
	settings_panel.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_resolution_selected(index: int) -> void:
	match index:
		0:
			get_window().size = Vector2i(1280, 720)
		1:
			get_window().size = Vector2i(1920, 1080)
		2:
			get_window().size = Vector2i(960, 540)

func _on_preset_selected(index: int) -> void:
	print("[SETTINGS] Preset gráfico alterado para: ", index)

func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))
