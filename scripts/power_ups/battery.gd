extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player:
		player.health_component.set_health(player.health_component.max_health)
