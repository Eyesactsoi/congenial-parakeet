extends CharacterBody2D
signal hit

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#intializing our variables
@export var speed = 400
var screen_size
var selfSpeed := 0.0
var acceleration := 2.5
var lastDirection: float

const MAX_SPEED = 600.0
const  jump_speed = -250.0

func _physics_process(delta):
	#adds gravity to the player
	velocity.y += gravity * delta
	
	#if the player is going to jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	
	# Gets Directional Input
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	move_and_slide()
