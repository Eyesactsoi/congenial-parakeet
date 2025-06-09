class_name Player extends CharacterBody2D

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Intializing the export ones
@onready var camera := $Camera as Camera2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@export var action_suffix := ""

# Intializing our variables
const walkSpeed = 200.0
const accelerationSpeed = walkSpeed * 6.0
const jumpVelocity = -250.00
# Intializing the maximum speed that a player can fall at
const terminalVelocity = 700


#func _ready():
#	screen_size = get_viewport_rect().size
	#hide()

func _physics_process(delta: float) -> void:
	# Fall.
	velocity.y = minf(terminalVelocity, velocity.y + gravity * delta)

	# if the player is going to jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Gets Directional Input
	var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * walkSpeed
	velocity.x = move_toward(velocity.x, direction, delta + 2.7)

	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			sprite.scale.x = 1.0
		else:
			sprite.scale.x = -1.0
	# Adds the half push for the character
	#if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") and Input.is_physical_key_pressed(KEY_SHIFT):
	#	velocity.x = (direction * accelerationSpeed) / 5

	move_and_slide()
