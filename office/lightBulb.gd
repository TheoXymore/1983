extends Node3D

var time:Timer = Timer.new()
var initial_rotation = 0

@onready var lumiere_plafond: SpotLight3D = $Lumiere_Plafond

func _ready() -> void:
	_flicker()

func _flicker() -> void:
	var tween := create_tween()
	tween.tween_property(lumiere_plafond, "light_energy", 0.1, randf_range(0.02, 0.08))
	tween.tween_property(lumiere_plafond, "light_energy", 1.0, randf_range(0.02, 0.08))
	tween.tween_interval(randf_range(0.1, 2.0))     # pause aléatoire entre deux flickers
	tween.finished.connect(_flicker)                # relance avec de nouvelles valeurs aléatoires

func _process(delta: float) -> void:
	rotation.z = initial_rotation + sin(Time.get_ticks_msec()*delta/10)/10
	
