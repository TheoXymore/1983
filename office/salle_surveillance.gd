extends Node3D

@export var ecrans:Array[Screen]

@export var rues:Array[PackedScene]
var rues_scenes:Array[SubViewport]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in ecrans.size():
		var rue = rues[i].instantiate()
		add_child(rue)
		rues_scenes.append(rue)
		
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = rue.get_texture()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		ecrans[i].window.material_override = mat
		
		ecrans[i].rue = rue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
