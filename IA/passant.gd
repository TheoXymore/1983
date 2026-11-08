extends Area3D
class_name Passant

var checkpoints:Array[Vector3]
var position_pool:int
var vitesse:float = 2.
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


signal arrive(passant:Passant)

var tween:Tween
var trajet: Array[Etape] = []
var etape_courante = 0
var suspect : bool = false

func activer(depart:Vector3,nouveau_trajet:Array[Etape])-> void:
	global_position = depart
	suspect = false
	trajet = nouveau_trajet
	collision_shape_3d.disabled= false
	lancer_depuis(0)

func desactiver()-> void:
	if tween and tween.is_valid():
		tween.kill()
	suspect = false	
	collision_shape_3d.disabled = true
	
	
func lancer_depuis(debut:int):
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	
	var pos_prec = global_position
	for i in range(debut, trajet.size()):
		var e = trajet[i]
		var duree = pos_prec.distance_to(e.position)/vitesse
		tween.tween_property(self,"global_position",e.position,duree)
		if e.attente > 0.0:
			tween.tween_callback(debut_attente.bind(i))
			tween.tween_interval(e.attente)
			tween.tween_callback(fin_attente)
		pos_prec = e.position
	tween.tween_callback(termine)
	
func debut_attente(index:int)->void:
	etape_courante = index
	suspect = est_suspect()
	
func fin_attente()->void:
	suspect = false

func termine(): arrive.emit(self)

func est_suspect()->bool:
	return false
	
func interrompre()->bool:
	if not suspect:
		return false
	suspect = false
	lancer_depuis(etape_courante+1)
	return true


func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
