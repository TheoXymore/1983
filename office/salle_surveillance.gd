extends Node3D

@export var ecrans:Array[Screen]

@export var rue: PackedScene
@export_range(0.0,100.0,1.0) var world_height: float = 10.0
var camViewports: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rue_node: Node3D = rue.instantiate()
	add_child(rue_node)
	rue_node.position.y = world_height;
	camViewports = rue_node.get_child(1)
	for i in camViewports.get_child_count():
		var svp: SubViewport = camViewports.get_child(i)
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = svp.get_texture()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		ecrans[i].window.material_override = mat
		ecrans[i].svp = svp
		
		var cam: Camera3D = svp.get_child(0)
		cam.position.y += world_height


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
