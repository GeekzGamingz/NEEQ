#Inherits StateMachine Code
extends NeeqFSM_Input
class_name NeeqFSM_Logic
#-------------------------------------------------------------------------------------------------#
#State Logistics
func state_logic(delta):
	if p.controllable:
		if ![states.wall_slide, states.wall_jump, states.ledge].has(state):
			p.handle_movement()
		p.moveDirection()
		p.apply_gravity(delta)
		p.apply_movement()
	match(state):
		states.idle: pass
