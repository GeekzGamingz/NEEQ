#Inherits StateMachine Code
extends StateMachine
#-------------------------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p = get_parent()
@onready var state_label: Label = p.get_node("Outputs/StateOutput")
#-------------------------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	state_add("idle")
	state_add("walk_left")
	state_add("walk_right")
	state_add("chase")
	state_add("attack")
	call_deferred("state_set", states.idle)
#-------------------------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	state_label.text = str(states.keys()[state])
#-------------------------------------------------------------------------------------------------#
#State Machine
#State Logistics
func state_logic(delta):
	p.handle_movement()
	p.apply_gravity(delta)
	p.apply_movement()
	match(state):
		states.idle: pass
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
		#Idle
		states.idle: if p.velocity.x != 0: return states.walk_right
		#Walk
		states.walk_left:
			if p.wall_detector1.is_colliding(): return states.walk_right
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_right
		states.walk_right:
			if p.wall_detector1.is_colliding(): return states.walk_left
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_left
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
		states.walk_left:
			p.playback.travel("walk")
			p.swap_direction()
			p.direction_timer.start()
		states.walk_right:
			p.playback.travel("walk")
			p.swap_direction()
			p.direction_timer.start()
		states.chase: p.playback.travel("walk")
		states.attack: p.playback.start("attack")
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.idle: pass
		states.walk_left, states.walk_right:
			p.wall_detector1.enabled = false
			await get_tree().create_timer(0.1).timeout
			p.wall_detector1.enabled = true
