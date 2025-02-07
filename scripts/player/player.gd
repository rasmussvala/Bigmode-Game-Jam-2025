extends CharacterBody2D

class_name Player

@export var time_to_live : float = 10
@export_category("Movement Settings")
@export var move_speed: float = 100
@export_subgroup("Dodge")
@export var dodge_speed: float = 300
@export var dodge_duration: float = 0.4
@export var dodge_cooldown: float = 0.5
@export_subgroup("Jump")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_power = 300


@onready var animated_sprite := $animationPlayer
@onready var camera := $Camera2D
@onready var hurtbox := $Hurtbox

@onready var health_component: HealthComponent = $HealthComponent

var dodge_timer: Timer
var dodge_cooldown_timer: Timer
var can_dodge := true
var in_dodge := false
var player_dead := false

var can_move := true
var is_falling: bool = false
var is_jumping := false

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	health_component.max_health = int(
		health_component.current_health
	)
	health_component.current_health = int(
		health_component.current_health
	)

	dodge_timer = Timer.new()
	add_child(dodge_timer)
	dodge_timer.wait_time = dodge_duration
	dodge_timer.one_shot = true
	dodge_timer.timeout.connect(_on_dodge_ended)

	dodge_cooldown_timer = Timer.new()
	add_child(dodge_cooldown_timer)
	dodge_cooldown_timer.wait_time = dodge_cooldown
	dodge_cooldown_timer.one_shot = true
	dodge_cooldown_timer.timeout.connect(func(): can_dodge = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	_health_tick_down(delta)
	if can_move:
		move_player(delta)

func _health_tick_down(delta):
	var damage_per_second = health_component.max_health / time_to_live
	health_component.damage(damage_per_second * delta)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	if can_move:
		move_and_slide()


func _unhandled_input(event):
	if player_dead:
		return
	if is_on_floor() and event.is_action_pressed("jump"):
		velocity.y = -jump_power;

	if can_dodge and event.is_action_pressed("dodge"):
		start_dodge()


func move_player(delta : float) -> void:
	if not in_dodge:
		var horizontal_input = Input.get_axis("move_left", "move_right")
		var l_acceleration = 10 if is_on_floor() else 5
		velocity.x = lerp(velocity.x, horizontal_input * move_speed, l_acceleration * delta)
		
		# Check if input is actively being pressed
		if Input.is_action_pressed("move_left"): 
			animated_sprite.play("runAnimationLeft")  # Play run animation when moving
		elif Input.is_action_pressed("move_right"):
			animated_sprite.play("runAnimationRight")  # Play run animation when moving
		else:
			animated_sprite.play("idleAnimation")  # Play idle animation when no input

func start_dodge() -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		# Normalize the vector to get a consistent dodge direction.
		var dodge_dir = input_vector.normalized()
		# If the player is only pressing left or right (no vertical input),
		# force the dodge direction to be upward as well.
		if dodge_dir.x != 0 and dodge_dir.y == 0:
			dodge_dir = Vector2(dodge_dir.x, -1).normalized()

		can_dodge = false
		in_dodge = true
		velocity = dodge_dir * dodge_speed
		# If dodging upward, add a little extra boost.
		if velocity.y < 0:
			velocity.y *= 1.2
		print(velocity)

		dodge_timer.start()
		animated_sprite.play("jumpAnimation")

	
func play_dodge_sound() -> void:
	var random_number = randi_range(1, 3)
	var sound: AudioStream = load("res://player/assets/sounds/dodge_" + str(random_number) + ".ogg")
	var player = AudioStreamPlayer.new()
	
	player.stream = sound
	player.bus = "UI"
	
	add_child(player)
	
	player.play()
	player.connect("finished", Callable(player, "queue_free"))

func _on_dodge_ended() -> void:
	in_dodge = false
	dodge_cooldown_timer.start()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		is_falling = velocity.y > 0

func _on_health_component_health_changed(amount: Variant) -> void:
	if amount > 0:
		return
	if !player_dead:
		flash_red(animated_sprite)
		camera.screen_shake()

func flash_red(sprite: AnimatedSprite2D) -> void:
	var tween = create_tween()
	var time = 0.05
	tween.tween_property(sprite, "modulate", Color(0.8, 0.2, 0.2), time)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), time)

func _on_health_component_died() -> void:
	player_dead = true
	set_process(false)
	set_physics_process(false)
	can_move = false
	animated_sprite.play("die")
	#death_screen.fade_in()
