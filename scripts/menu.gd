extends Control

@onready var start_button: Button = $StartButton

func _ready() -> void:
	start_button.pressed.connect(start_game)
	
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	
