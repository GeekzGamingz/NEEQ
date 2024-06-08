#Inherits Node Code
extends Node
class_name StateMachine
#------------------------------------------------------------------------------#
#Variables
var state = null: set = state_set
var state_prev = null
var states = {}
#------------------------------------------------------------------------------#
#State Machine
func _physics_process(delta: float) -> void:
	if state != null:
		state_logic(delta)
		var transition = transitions(delta)
		if transition != null: state_set(transition)
#State Logistics
@warning_ignore("unused_parameter")
func state_logic(delta: float): pass
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta: float): return null
#Enter State
@warning_ignore("unused_parameter")
func state_enter(state_new: int, state_old: int): pass
#Exit State
@warning_ignore("unused_parameter")
func state_exit(state_old: int, state_new: int): pass
#Set State
func state_set(state_new: int):
	state_prev = state
	state = state_new
	if state_prev != null: state_exit(state_prev, state_new)
	if state_new != null: state_enter(state_new, state_prev)
#Add State
func state_add(state_name: String):
	states[state_name] = states.size()
