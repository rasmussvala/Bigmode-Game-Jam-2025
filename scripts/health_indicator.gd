extends PointLight2D

@export_range(1, 3, 0.2) var energy_modifier : float = 1
	
@onready var hc := $"../HealthComponent" 

func _ready() -> void:
	energy = energy_modifier
	hc.health_changed.connect(_on_hp_changed)

func _on_hp_changed(health : int):
	energy = (float(hc.current_health) / hc.max_health) * energy_modifier
