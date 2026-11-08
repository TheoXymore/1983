extends Node3D

@export var ecrans:Array[Screen]

@export var rue: PackedScene
@export_range(0.0,100.0,1.0) var world_height: float = 10.0
var cam_viewports: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rue_node: Rue = rue.instantiate()
	add_child(rue_node)
	rue_node.position.y = world_height;
	cam_viewports = rue_node.get_child(1)
	var n_cam_viewports = cam_viewports.get_child_count()
	for i in ecrans.size():
		var mat = StandardMaterial3D.new()
		
		if i < n_cam_viewports:
			var svp: SubViewport = cam_viewports.get_child(i)
			mat.albedo_texture = svp.get_texture()
			ecrans[i].svp = svp
			svp.get_child(0).position.y += world_height
		else:
			mat.albedo_texture = NoiseTexture2D.new()
			var noise := FastNoiseLite.new()
			noise.noise_type = FastNoiseLite.TYPE_VALUE
			noise.offset = Vector3(randi(),randi(),randi())
			mat.albedo_texture.noise = noise
			
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		ecrans[i].window.material_override = mat
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
	for ecran in ecrans:
		if !ecran.enabled:
			ecran.window.material_override.albedo_texture.noise.offset = Vector3(randi(),randi(),randi())
