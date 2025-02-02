extends PointLight2D

@export_range(1, 10, 0.2) var energy_modifier : float = 1
	
@onready var hc := $"../HealthComponent" 

func _ready() -> void:
	energy = energy_modifier
	hc.health_changed.connect(_on_hp_changed)

func _on_hp_changed(health : int):
	energy = (float(hc.current_health) / hc.max_health) * energy_modifier
	if energy < -0.2:
		reload_scene()

func reload_scene() -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		get_tree().reload_current_scene()
