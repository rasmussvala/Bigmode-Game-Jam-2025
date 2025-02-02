extends Node
class_name HealthComponent

@export var max_health: float = 100:
	set(value):
		max_health = value
		max_health_changed.emit(max_health)
@export var current_health: float = 100

var can_take_damage := true

signal health_changed(current_health)
signal max_health_changed(max_health)
signal died


func damage(amount: float) -> void:
	current_health -= amount
	if can_take_damage and current_health <= 0:
		can_take_damage = false
		current_health = 0
		died.emit()
	health_changed.emit(-amount)


func heal(amount: float) -> void:
	if current_health >= max_health:
		return
	print("current_health ", current_health)
	print("max_health ", max_health)

	current_health += amount
	if current_health >= max_health:
		current_health = max_health
	health_changed.emit(amount)


func set_health(amount: float) -> void:
	current_health = min(amount, max_health)
	current_health = max(current_health, 0)

	if current_health == 0:
		died.emit()


func is_dead() -> bool:
	return current_health == 0


#var floating_text = preload("res://common/effects/floating text/floating_text.tscn")


#TODO Extract functions to another component?
#func _ready():
#	connect("health_changed", _on_health_changed)


#func _on_health_changed(amount: int):
#	var text = floating_text.instantiate()
#	text.amount = amount
#	text.position = get_parent().position
#	get_tree().root.add_child(text)
