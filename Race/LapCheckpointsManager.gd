extends Node
class_name LapCheckpointsManager

signal lap_completed(car: Node, lap_number: int, lap_time: float)
signal checkpoint_passed(car: Node, checkpoint_idx: int)

@export var checkpoints: Array[Area3D] = []
var car_progress: Dictionary = {} # car_node -> { "current_cp": int, "current_lap": int, "lap_start_time": float }

func _ready() -> void:
	for i in range(checkpoints.size()):
		var cp = checkpoints[i]
		if cp:
			cp.body_entered.connect(_on_checkpoint_entered.bind(i))

func register_car(car: Node) -> void:
	car_progress[car] = {
		"current_cp": 0,
		"current_lap": 1,
		"lap_start_time": Time.get_ticks_msec() / 1000.0,
		"best_lap_time": 999999.0
	}

func _on_checkpoint_entered(body: Node, cp_index: int) -> void:
	if not car_progress.has(body):
		return
	
	var prog = car_progress[body]
	var expected_cp = prog["current_cp"]
	
	if cp_index == expected_cp:
		checkpoint_passed.emit(body, cp_index)
		prog["current_cp"] = (expected_cp + 1) % checkpoints.size()
		
		# Cruzou a linha de chegada (checkpoint 0 após o último)
		if prog["current_cp"] == 0:
			var now = Time.get_ticks_msec() / 1000.0
			var lap_time = now - prog["lap_start_time"]
			prog["lap_start_time"] = now
			
			if lap_time < prog["best_lap_time"]:
				prog["best_lap_time"] = lap_time
			
			lap_completed.emit(body, prog["current_lap"], lap_time)
			prog["current_lap"] += 1
