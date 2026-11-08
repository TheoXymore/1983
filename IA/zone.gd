extends Area3D
class_name Zone

@onready var forme: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func point_aleatoire() -> Vector3:
	var taille: Vector3 = (forme.shape as BoxShape3D).size
	var local := Vector3(
		randf_range(-taille.x / 2.0, taille.x / 2.0),
		randf_range(-taille.y / 2.0, taille.y / 2.0),
		randf_range(-taille.z / 2.0, taille.z / 2.0)
	)
	return forme.to_global(local)
