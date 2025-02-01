extends CharacterBody2D

var speed: float = 20.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right: bool = true

# Raycast for ground detection
@onready var ground_ray: RayCast2D = $GroundRay
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

	if !ground_ray.is_colliding() && is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right

	scale.x = abs(scale.x) * -1

	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
