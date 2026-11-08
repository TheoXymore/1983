extends CanvasLayer
class_name DialogueBox

signal dialogue_finished

@onready var panel: PanelContainer = $Panel
@onready var caller_label: Label = $Panel/VBoxContainer/CallerLabel
@onready var text_label: Label = $Panel/VBoxContainer/TextLabel

@export var character_per_second = 30.0
@export var display_time_after_text = 3

var typing_tween: Tween

func _ready() -> void:
	panel.hide()

func show_dialogue(caller_name: String, dialogue_text: String):
	caller_label.text = caller_name
	text_label.text = dialogue_text
	text_label.visible_ratio = 0.0
	panel.show()
	
	if typing_tween and typing_tween.is_valid():
		typing_tween.kill()
	
	var typing_duration = dialogue_text.length() / character_per_second
	typing_tween = create_tween()
	typing_tween.tween_property(text_label, "visible_ratio", 1.0, typing_duration)
	await typing_tween.finished
	
	await get_tree().create_timer(display_time_after_text).timeout
	panel.hide()
	dialogue_finished.emit()
