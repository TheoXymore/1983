extends Node

signal phone_call_started(call_data: Dictionary)
signal day_ended(day_finished: int)

const DAYS_FILE_PATH: String = "res://story/story.json"
var days_data: Dictionary = {}
var current_day = 1
var current_call_index = 0

func _ready():
	load_days_from_json()
	
func load_days_from_json():
	var day_file = FileAccess.open(DAYS_FILE_PATH, FileAccess.READ)
	days_data = JSON.parse_string(day_file.get_as_text())
	
func get_calls_of_the_day():
	return days_data.get(str(current_day), {}).get("calls", [])
	
func start_next_call_of_the_day():
	var calls: Array = get_calls_of_the_day()
	while current_call_index < calls.size():
		var call_data: Dictionary = calls[current_call_index]
		current_call_index += 1
		phone_call_started.emit(call_data)
		return
	end_current_day()
	
func has_remaining_calls_today():
	var calls: Array = get_calls_of_the_day()
	if current_call_index < calls.size():
		return true
	return false

func end_current_day():
	day_ended.emit(current_day)
	current_call_index = 0
	current_day += 1
