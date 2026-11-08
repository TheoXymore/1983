extends Zone
class_name ZoneRassemblement

@export var checkpoint_precedent:Zone
@export_range(0.0,1.0) var probabilite: float = 0
@export var attente_min:float = 3.0
@export var attente_max:float = 8.0

var passants:Array[Passant]

func _on_area_entered(area: Area3D) -> void:
	if area is Passant:
		passants.append(area)

func _on_area_exited(area: Area3D) -> void:
	if area is Passant:
		var index = passants.find(area)
		if index >= 0 and index < passants.size():
			passants.remove_at(index)

func disperse() -> void:
	for passant in passants:
		# if passant.est_suspect(): game_state.augmenter_score()
		passant.lancer_depuis(passant.etape_courante+1)
