extends SubViewport
class_name Rue

var pool_passants:Pool = Pool.new()

@export var scenes_passants:Array[SpawnPassant]
@export var taille_initiale = 100

@export var spawn:ZoneSpawn
@export var checkpoints: Array[ZoneCheckpoint]
@export var rassemblements:Array[ZoneRassemblement]

var timer_spawn: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pool_passants.scenes_passants = scenes_passants
	pool_passants.taille_initiale = taille_initiale
	add_child(pool_passants)
	
	add_child(timer_spawn)
	timer_spawn.one_shot = false
	timer_spawn.timeout.connect(spawn_passant)
	timer_spawn.start()

	
func construire_trajet()-> Array[Etape]:
	var etapes:Array[Etape] = []
	ajouter_rassemblements(spawn,etapes)
	for k in checkpoints:
		etapes.append(Etape.new(k.point_aleatoire()))
		ajouter_rassemblements(k,etapes)
	return etapes
	
	
func ajouter_rassemblements(zone_precedente:Zone,etapes:Array[Etape])->void:
	for r in rassemblements:
		if r.checkpoint_precedent == zone_precedente and randf()< r.probabilite:
			etapes.append(Etape.new(
				r.point_aleatoire(),
				randf_range(r.attente_min,r.attente_max)
			))
			

func spawn_passant()-> void:
	var p: Passant = pool_passants.obtenir()
	p.activer(spawn.point_aleatoire(),construire_trajet())
