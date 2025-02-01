extends Area2D

const FILE_BEGIN = "res://scenes/levels/level_"

func _on_body_entered(_body: Node2D) -> void:
	# find current scene number
	var current_scene_file = get_tree().current_scene.scene_file_path
	var current_number = current_scene_file.to_int()
	
	# last level will trigger end scene
	if current_number == 10:
		get_tree().change_scene_to_file("res://scenes/end.tscn")
		return
	
	# construct next level path
	var next_level_number = current_number + 1
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	
	# change scene 
	get_tree().change_scene_to_file(next_level_path)
