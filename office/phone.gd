extends StaticBody3D
class_name Phone

var is_ringing = false
var current_call
@export var delay_before_next_ring = 5

func _ready() -> void:
	StoryManager.phone_call_started.connect(on_phone_call_started)
	StoryManager.day_ended.connect(on_day_ended)
	ring_phone()

func ring_phone():
	is_ringing = true
	print("Le téléphone sonne ...")

func try_to_answer():
	if is_ringing == false:
		print("Le téléphone ne sonne pas")
	else :
		is_ringing = false
		StoryManager.start_next_call_of_the_day()

func on_phone_call_started(call_data):
	current_call = call_data
	print(call_data["caller"], " : ", call_data["text"])
	if not StoryManager.has_remaining_calls_today():
		StoryManager.end_current_day()
	finish_current_call()
	
func finish_current_call():
	await get_tree().create_timer(delay_before_next_ring).timeout
	ring_phone()
	
func on_day_ended(finished_day: int):
	print("Fin du jour ", finished_day)
