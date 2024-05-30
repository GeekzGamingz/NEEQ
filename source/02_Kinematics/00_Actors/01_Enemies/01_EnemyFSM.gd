#Inherits StateMachine Code
extends StateMachine
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p = get_parent()
@onready var state_label: Label = p.get_node("Outputs/StateOutput")
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	#Add States
	state_add("idle")
	state_add("walk")
	state_add("chase")
	state_add("attack")
	call_deferred("state_set", states.idle)
#------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	state_label.text = str(states.keys()[state])
#------------------------------------------------------------------------------#
#State Machine
#State Logistics
func state_logic(delta):
	p.handle_movement()
	p.move_direction()
	p.apply_gravity(delta)
	p.apply_movement()
	match(state):
		states.idle: pass
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
		#Idle
		states.idle: pass
		#Walk
		states.walk: pass
		#Chase
		states.chase: pass
		#Attack
		states.attack: pass
	return null
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
		states.idle: p.playback.travel("idle")
		states.walk: p.playback.travel("walk")
		states.chase: p.playback.travel("walk")
		states.attack: p.playback.start("attack")
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.idle: pass
