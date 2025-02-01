extends CharacterBody2D

class_name Player

@export_category("Movement Settings")
@export var move_speed: float = 100
@export_subgroup("Dodge")
@export var dodge_speed: float = 300
@export var dodge_duration: float = 0.4
@export var dodge_cooldown: float = 0.5
@export_subgroup("Jump")
@export var gravity = 10
@export var jump_power = 300

@onready var animated_sprite := $AnimatedSprite2D
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
	handle_gravity()
	if can_move:
		move_player(delta)

func _physics_process(_delta: float) -> void:
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
		var horizontal_input = (
			Input.get_axis("move_left", "move_right")
		)
		var l_acceleration = 10 if is_on_floor() else 1
		velocity.x = lerp(velocity.x, horizontal_input * move_speed, l_acceleration * delta)
		if abs(velocity.x) < 0.1:
			velocity.x = 0


func start_dodge() -> void:
	can_dodge = false
	in_dodge = true
	var dodge_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	print(dodge_dir)
	velocity = dodge_dir * dodge_speed
		
	dodge_timer.start()
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, false)
	animated_sprite.play("roll_h")
	hurtbox.is_invulnerable = true
	play_dodge_sound()

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
	hurtbox.is_invulnerable = false
	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
	dodge_cooldown_timer.start()

func handle_gravity() -> void:
	if not is_on_floor():
		velocity.y += gravity
		is_falling = velocity.y > 0
	else:
		velocity.y = gravity

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
