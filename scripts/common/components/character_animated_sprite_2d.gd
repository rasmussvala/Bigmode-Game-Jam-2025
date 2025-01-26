class_name CharacterAnimatedSprite2D extends AnimatedSprite2D

@onready var parent = get_parent() as CharacterBody2D

var player = AudioStreamPlayer.new()
var wait_time: float = 0.0 
var elapsed_time: float = 0.0
var sound_playing: bool = false 

var dead = false

func _ready() -> void:
	var hp = parent.get_node("HealthComponent") as HealthComponent
	hp.died.connect(func():
		stop()
		dead = true
		)
	set_new_wait_time() 
	add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !dead:
		animate()
		handle_sounds(delta)

func animate() -> void:
	if parent.velocity.x != 0:
		play("run_h")
		if parent.velocity.x > 0.0:
			flip_h = false
		elif parent.velocity.x < 0.0:
			flip_h = true
	else:
		play("idle")

func set_new_wait_time() -> void:
	wait_time = randf_range(3, 7)
	elapsed_time = 0.0

func handle_sounds(delta: float) -> void:
	elapsed_time += delta

	if elapsed_time >= wait_time and !sound_playing:
		#emit_sound()
		sound_playing = true

	if player.playing and player.get_playback_position() >= player.stream.get_length():
		sound_playing = false
		set_new_wait_time()


func emit_sound() -> void:
	var random_number = randi_range(1, 8)
	var path: String = "res://enemies/assets/audio/misc/enemy_misc_sound_" + str(random_number) + ".ogg"
	var sound: AudioStream = load(path)

	player.stream = sound
	player.bus = "Weapon"
	player.play()
