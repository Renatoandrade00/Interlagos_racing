extends Control
class_name CountdownController

signal countdown_finished

@onready var label_countdown: Label = $LabelCountdown
@onready var anim_timer: Timer = $Timer

var count_step: int = 3

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	label_countdown.text = "3"
	label_countdown.set("theme_override_colors/font_color", Color(1.0, 0.2, 0.2)) # Vermelho
	anim_timer.timeout.connect(_on_timer_tick)
	anim_timer.start(1.0)

func _on_timer_tick() -> void:
	count_step -= 1
	match count_step:
		2:
			label_countdown.text = "2"
			label_countdown.set("theme_override_colors/font_color", Color(1.0, 0.5, 0.1)) # Laranja
			anim_timer.start(1.0)
		1:
			label_countdown.text = "1"
			label_countdown.set("theme_override_colors/font_color", Color(1.0, 0.9, 0.1)) # Amarelo
			anim_timer.start(1.0)
		0:
			label_countdown.text = "GO!"
			label_countdown.set("theme_override_colors/font_color", Color(0.1, 1.0, 0.3)) # Verde
			anim_timer.start(0.8)
			countdown_finished.emit()
		_:
			visible = false
			anim_timer.stop()
