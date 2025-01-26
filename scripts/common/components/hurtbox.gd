class_name Hurtbox extends Area2D

@export var is_invulnerable: bool = false

@onready var health_component = $"../HealthComponent" as HealthComponent

func damage(amount: int) -> void:
	if !is_invulnerable:
		health_component.damage(amount)
