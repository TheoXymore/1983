extends RefCounted
class_name Etape

var position:Vector3
var attente:float= 0.0

func _init(pos:Vector3, att:float = 0.0) -> void:
	position = pos
	attente = att
