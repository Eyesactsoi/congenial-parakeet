class_name Player extends CharacterBody2D

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Intializing the export ones
@onready var camera := $Camera as Camera2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var pushcooldown := $Timer as Timer
@onready var jumptimer := $Timer2 as Timer
@onready var falltimer := $Timer3 as Timer
@export var action_suffix := ""
   
# Intializing our variables
const speed = 425
const accelerationSpeed = speed * 6.0
const jumpVelocity = -150.00
# Intializing the maximum speed that a player can fall at
const terminalVelocity = 700
const regularVelocity = 350
var counter = 0
var looking = Vector2.RIGHT
#var jumpSwitch = false

func _ready():
	print("hi")

func _physics_process(delta: float) -> void:
	#Jump
	if Input.is_action_just_pressed('jump') and is_on_floor() and jumptimer.is_stopped():
		velocity.y = jumpVelocity
		#jumpSwitch = false
	if not is_on_floor():
		jumpTimerStarter()
		#jumpSwitch = true
	fallTimer()
	# Fall
	if falltimer.time_left < 2.0:
		velocity.y = minf(terminalVelocity, (velocity.y + gravity * delta) - 3)
	else:
		velocity.y = minf(regularVelocity, (velocity.y + gravity * delta) - 7)
	move()
	print(get_floor_angle())
#	print(jumptimer.time_left)
	#print(get_floor_angle())
	#print(counter)
	counter = fakeMomentum(counter)
	move_and_slide()

func fakeMomentum(counters):
	counter = counters
	var angle = get_floor_angle()
	if velocity.x == 0 and counter > 15:
		counter = 0
		return counter
	#Fix the velocity of x on the slopes below, something is not right
	if angle > 0 and angle < 1 or angle < 0.0 and angle > -1.0:
		if counter > 15:
			if angle < 0.1 and angle > 0 or angle < -0.1 and angle > -0.2:
				if velocity.x > 0:
					velocity.x = round(velocity.x - 5)
				elif velocity.x < 0:
					velocity.x = round(velocity.x + 5)
			elif angle < 0.5 and angle > 0.1 or angle < -0.1 and angle > -0.5:
				if velocity.x > 0:
					velocity.x = round(velocity.x - 15)
				elif velocity.x < 0:
					velocity.x = round(velocity.x + 15)
			counter = 0
			return counter
	if counter > 15:
		if velocity.x > 50 and velocity.x > 0 or velocity.x < 0:
			if velocity.x > 0:
				velocity.x = round(velocity.x - 15)
			elif velocity.x < 0:
				velocity.x = round(velocity.x + 15)
			if velocity.x > 10 and velocity.x > 0 or velocity.x < 0:
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

func move():
	if pushTimer() and is_on_floor():
		if Input.is_action_just_pressed("push") and Input.is_action_pressed("move_left") or Input.is_action_just_pressed("push") and Input.is_action_pressed("move_right") and velocity.x == 0 and is_on_floor():
			var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * speed
			velocity.x = move_toward(velocity.x, direction, 70)
			pushcooldown.start()
		if Input.is_action_just_pressed("push") and Input.is_action_pressed("move_left") or Input.is_action_just_pressed("push") and Input.is_action_pressed("move_right") and is_on_floor():
			var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * speed
			velocity.x = move_toward(velocity.x, direction, 50)
			pushcooldown.start()
		if not is_zero_approx(velocity.x):
			if velocity.x > 0.0:
				sprite.scale.x = 1.0
			else:
				sprite.scale.x = -1.0
	else:
		pass

func pushTimer() -> bool:
	if pushcooldown.is_stopped():
		return true
	else:
		return false

func jumpTimerStarter():
	jumptimer.start()

func fallTimer():
	if is_on_floor():
		falltimer.start()
	else:
		return KEY_NONE
