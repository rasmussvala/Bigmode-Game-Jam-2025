extends Control

@onready var start_button: Button = $ContentMargin/ButtonsContainer/StartButton
@onready var exit_button: Button = $ContentMargin/ButtonsContainer/ExitButton

func _ready() -> void:
	init_buttons()
	
func start_game() -> void:
	print("Start game")
	# @TODO Add next scene/start animation

func exit_game() -> void:
	get_tree().quit()
	
func init_buttons() -> void:
	exit_button.pressed.connect(exit_game)
	start_button.pressed.connect(start_game)
