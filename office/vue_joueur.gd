extends Camera3D

const RAY_LENGTH = 1000

@export var mouse_sensitivity = 0.003
var current_pitch = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * RAY_LENGTH
		print("from :", from)
		print("to : ", to)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_camera(event.relative)

func rotate_camera(mouse_delta: Vector2) -> void:
	rotation.y -= mouse_delta.x * mouse_sensitivity
	current_pitch = clamp(current_pitch - mouse_delta.y * mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
	rotation.x = current_pitch 
