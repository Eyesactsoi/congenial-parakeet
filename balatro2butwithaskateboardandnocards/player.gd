extends CharacterBody2D
signal hit

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# intializing our variables
@export var speed = 400
var screen_size
var selfSpeed := 0.0
var acceleration := 2.5
var lastDirection: float

const MAX_SPEED = 600.0
const  jump_speed = -250.0

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _physics_process(delta):
	# adds gravity to the player
	velocity.y += gravity * delta
	
	# if the player is going to jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Gets Directional Input
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	# Adds the half push for the character
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") and Input.is_physical_key_pressed(KEY_SHIFT):
		velocity.x = (direction * speed) / 2

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.flip_v = velocity.y > 0

	move_and_slide()
