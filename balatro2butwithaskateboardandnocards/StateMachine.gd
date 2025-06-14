extends AnimatedSprite2D
class_name StateMachine

var state = null
var previous_state = null

@onready var parent = get_parent()

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _eneter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	_exit_state(previous_state, 
