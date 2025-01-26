class_name Hurtbox extends Area2D

@export var is_invulnerable: bool = false

@onready var health_component = $"../HealthComponent" as HealthComponent

@export_range(0, 100, 1, "or_greater") var armor: int = 0:
	set(value):
		armor = value
		armor_multiplier = 1 - 0.9 * (armor / (armor + 100))

# Pre-calculated value
var armor_multiplier: float = 1.0


func damage(amount: int) -> void:
	if !is_invulnerable:
		health_component.damage(int(amount * armor_multiplier))
