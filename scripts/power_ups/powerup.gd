class_name PowerUp

extends Area2D

func _apply_powerup(_player : Player):
	pass

func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player:
		_apply_powerup(player)
