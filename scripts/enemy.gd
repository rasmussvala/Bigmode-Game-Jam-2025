extends CharacterBody2D

var speed = 20.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var bob_timer = 0.0
var bob_amplitude = 0.1
var bob_frequency = 4.0
var base_scale = Vector2()

@onready var ground_ray = $GroundRay
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	
	base_scale = collision_shape_2d.scale

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if not ground_ray.is_colliding() and is_on_floor():
		flip()
	velocity.x = speed
	move_and_slide()
	
	# bobbing animation 
	bob_timer += delta
	var new_scale_y = base_scale.y + sin(bob_timer * bob_frequency) * bob_amplitude
	collision_shape_2d.scale = Vector2(collision_shape_2d.scale.x, new_scale_y)

func flip():
	facing_right = not facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = -abs(speed)
