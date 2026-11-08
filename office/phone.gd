extends StaticBody3D
class_name Phone

@export var dialogue_box: DialogueBox
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var icon: Sprite3D = $Icon

var timer:=Timer.new()
var initial_pos_y

var is_ringing = false
var current_call
@export var delay_before_next_ring = 10

func _ready() -> void:
	StoryManager.phone_call_started.connect(on_phone_call_started)
	StoryManager.day_ended.connect(on_day_ended)
	ring_phone()
	
	
	
	add_child(timer)
	timer.one_shot = false
	timer.wait_time = 2*PI
	timer.start()
	initial_pos_y = icon.global_position.y

func ring_phone():
	is_ringing = true
	print("Le téléphone sonne ...")
	audio.play()
	icon.show()
	

func try_to_answer():
	if is_ringing == false:
		print("Le téléphone ne sonne pas")
	else :
		is_ringing = false
		StoryManager.start_next_call_of_the_day()
		audio.stop()
		icon.hide()

func on_phone_call_started(call_data):
	current_call = call_data
	await dialogue_box.show_dialogue(call_data["caller"], call_data["text"])
	if StoryManager.has_remaining_calls_today():
		finish_current_call()
	else :
		StoryManager.end_current_day()
	
func finish_current_call():
	await get_tree().create_timer(delay_before_next_ring).timeout
	ring_phone()
	
func on_day_ended(finished_day: int):
	print("Fin du jour ", finished_day)
	
func _process(delta: float) -> void:
	if is_ringing:
		icon.global_position.y = initial_pos_y + sin(timer.time_left*2)/20
