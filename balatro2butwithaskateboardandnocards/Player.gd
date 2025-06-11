class_name Player extends CharacterBody2D

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Intializing the export ones
@onready var camera := $Camera as Camera2D
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@export var action_suffix := ""

# Intializing our variables
const speed = 200.0
const accelerationSpeed = speed * 6.0
const jumpVelocity = -195.00
# Intializing the maximum speed that a player can fall at
const terminalVelocity = 700
var right = Input.is_action_pressed("move_right")
var left = Input.is_action_pressed("move_left")
var push = Input.is_action_just_pressed("push")
var mod = Input.is_action_pressed("shifter")
var jump = Input.is_action_just_pressed("jump")
var counter = 0

func _physics_process(delta: float) -> void:
	#Jump
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = jumpVelocity
	# Fall
	velocity.y = minf(terminalVelocity, velocity.y + gravity * delta)
	if Input.is_action_just_pressed("push") and Input.is_action_pressed("move_left") or Input.is_action_just_pressed("push") and Input.is_action_pressed("move_right"):
		var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * speed
		velocity.x = move_toward(velocity.x, direction, 50)
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			sprite.scale.x = 1.0
		else:
			sprite.scale.x = -1.0
	print(velocity.x)
	counter = fakeMomentum(counter)
	move_and_slide()

func _ready():
	print("hi")

func fakeMomentum(counter):
	if counter > 15:
		if velocity.x > 50 and velocity.x > 0 or velocity.x < 0:
			if velocity.x > 0:
				velocity.x = round(velocity.x - 15)
			elif velocity.x < 0:
				velocity.x = round(velocity.x + 15)
		if velocity.x < 10 and velocity.x > 0 or velocity.x < 0:
			if velocity.x > 0:
				velocity.x = round(velocity.x - 5)
			elif velocity.x < 0:
				velocity.x = round(velocity.x + 5)
		elif velocity.x > 0 or velocity.x < 0:
			if velocity.x > 0:
				velocity.x = round(velocity.x - 10)
			elif velocity.x < 0:
				velocity.x = round(velocity.x + 10)
		counter = 0
		return counter
	counter += 1
	return counter
