extends Node3D
class_name Pool

var scenes_passants:Array[SpawnPassant]
var taille_initiale = 100

var libres:Array[Passant] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in taille_initiale:
		libres.append(creer())
		
func select_scene()->PackedScene:
	var poids := PackedFloat32Array()
	for e in scenes_passants:
		poids.append(e.poids)
	var rng := RandomNumberGenerator.new()
	return scenes_passants[rng.rand_weighted(poids)].scene

func creer()-> Passant:
	var p:Passant = scenes_passants.pick_random().instantiate()
	add_child(p)
	p.desactiver()
	p.arrive.connect(passant_arrive)
	return p
	
func obtenir()->Passant:
	if libres.is_empty():
		return creer()
	return libres.pop_back()
	
func passant_arrive(p:Passant)->void:
	if p.checkpoints.size() == 0:
		p.desactiver()
		libres.append(p)
	else : 
		p.aller_a(p.checkpoints.pop_front(),p.temps_trajet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
