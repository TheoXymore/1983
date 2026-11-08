extends Camera3D

@export_range(0.0, 90.0, 1.0) var max_angle_left = 60.0
@export_range(0.0, 90.0, 1.0) var max_angle_right = 15.0
@export_range(0.0, 90.0, 1.0) var max_angle_up = 0.0
@export_range(0.0, 90.0, 1.0) var max_angle_down = 30.0

@export_range(0.1, 1.0, 0.1) var mouse_sensitivity = 0.1
@export_range(0.1, 1.0, 0.1) var camera_speed = 0.1

@onready var shapecast: ShapeCast3D = $ShapeCast3D

var y_rot: float
var x_rot: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	y_rot = rad_to_deg(rotation.y)
	x_rot = rad_to_deg(rotation.x)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_camera(event.relative)

func rotate_camera(mouse_delta: Vector2) -> void:
	y_rot = clamp(y_rot - mouse_delta.x * mouse_sensitivity * camera_speed, max_angle_right, max_angle_left)
	x_rot = clamp(x_rot - mouse_delta.y * mouse_sensitivity * camera_speed, -max_angle_down, max_angle_up)
	rotation.y = deg_to_rad(y_rot)
	rotation.x = deg_to_rad(x_rot)
	
func catch_npc():
	var npcs = shapecast.collision_result
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		catch_npc()
	
