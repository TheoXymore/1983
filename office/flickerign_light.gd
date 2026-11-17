extends SpotLight3D

##Temps minimum entre deux vagues de clignotements
@export var pause_min: float = 1.0
##Temps maximum entre deux vagues de clignotements
@export var pause_max: float = 3.0 
##Nombre de clignotements minimum à chaque proc
@export var clignotements_min:int = 2
##Nombre de clignotements maximum à chaque proc
@export var clignotements_max:int = 6
##Temps minimum entre deux clignottements
@export var duree_min:float = 0.03
##Temps maximum entre deux clignottements
@export var duree_max:float = 0.12

var tween:Tween

func _ready()->void:
	light_energy = 1
	setup_next_flicker()
	
func setup_next_flicker()->void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	
	#Attendre jusqu'à la prochaine vague	
	tween.tween_interval(randf_range(pause_min,pause_max))

	#vague de clignotements
	for i in randi_range(clignotements_min,clignotements_max):
		tween.tween_callback(_set_energy.bind(0.0))
		tween.tween_interval(randf_range(duree_min,duree_max))
		tween.tween_callback(_set_energy.bind(1.0))
		tween.tween_interval(randf_range(duree_min,duree_max))
		
	#on relance bébé
	tween.tween_callback(setup_next_flicker)
	
		
func _set_energy(value:float):
	light_energy = value
