extends Camera3D

const RAY_LENGTH = 1000

@onready var ray_cast_3d: RayCast3D = $RayCast3D
var is_camera_selected = false
var mouse_sensitivity = 0.003
var current_pitch = 0.0

var rues: Array

var collided_object
var current_object

@onready var tween = get_tree().create_tween()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		if not is_camera_selected:
			rotate_camera(event.relative)
		elif current_object.svp.has_node("Camera"):
			current_object.svp.get_node("Camera").rotate_camera(event.relative)

func rotate_camera(mouse_delta: Vector2) -> void:
	rotation.y -= mouse_delta.x * mouse_sensitivity
	current_pitch = clamp(current_pitch - mouse_delta.y * mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
	rotation.x = current_pitch 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		select_screen_under_crosshair()
	if Input.is_action_just_pressed("cancel") and is_camera_selected:
		move_camera_to_global_position(Vector3(0,1.6,-0.2), Vector3.ZERO, true)
		
func select_screen_under_crosshair():
	collided_object = ray_cast_3d.get_collider()
	
	if collided_object is Screen:
		current_object = collided_object
		print(current_object)
		move_camera_to_global_position(current_object.anchor.global_position, current_object.anchor.global_rotation, false)
		
	elif collided_object is Phone:
		current_object = collided_object
		print(current_object)
		current_object.try_to_answer()

func move_camera_to_global_position(position, rotation, can_move):
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", position, 0.2)
	tween.parallel().tween_property(self, "global_rotation", rotation, 0.2)
	tween.tween_callback(change_bool.bind(can_move))

func change_bool(can_move):
	is_camera_selected = not can_move
