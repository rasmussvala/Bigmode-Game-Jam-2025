extends Control

@onready var start_button: Button = $ButtonsContainer/StartButton
@onready var exit_button: Button = $ButtonsContainer/ExitButton

func _ready() -> void:
	init_buttons()
	
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func exit_game() -> void:
	get_tree().quit()
	
func init_buttons() -> void:
	exit_button.pressed.connect(exit_game)
	start_button.pressed.connect(start_game)
