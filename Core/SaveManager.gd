extends Node
class_name SaveManager

const SAVE_PATH = "user://save_data.json"

static var default_data = {
	"best_laps": {
		"interlagos_vertical_slice": 0.0
	},
	"settings": {
		"resolution_index": 0,
		"graphics_preset": 0,
		"master_volume": 80.0,
		"driving_assists": {
			"abs": true,
			"tcs": true,
			"esp": true
		}
	}
}

static func save_game(data: Dictionary) -> bool:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		return false
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	return true

static func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return default_data.duplicate(true)
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return default_data.duplicate(true)
	
	var content = file.get_as_text()
	file.close()
	
	var parsed = JSON.parse_string(content)
	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed
	return default_data.duplicate(true)
