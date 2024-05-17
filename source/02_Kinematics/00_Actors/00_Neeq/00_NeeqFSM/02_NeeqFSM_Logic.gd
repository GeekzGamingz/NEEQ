#Inherits StateMachine Code
extends NeeqFSM_Input
class_name NeeqFSM_Logic
#-------------------------------------------------------------------------------------------------#
#State Logistics
func state_logic(delta):
	if p.controllable:
		p.handle_mode()
		p.move_direction()
		if ![states.wall_slide, states.wall_slide_quick, states.wall_jump,
			states.ledge, states.combat_downthrust, states.combat_jump_fall].has(state):
			p.handle_movement()
		p.apply_gravity(delta)
		p.apply_movement()
	match(state):
		states.idle: pass
		states.fall: p.jumping = true if p.coyote_timer.is_stopped() else false
		states.wall_slide, states.wall_slide_quick, states.skid: p.jump_particles()
		states.dodge, states.dodge_air:
			if p.facing.x == p.FACING_RIGHT: p.velocity.x = -10 * G.TILE_SIZE
			else: p.velocity.x = 10 * G.TILE_SIZE
			p.dodge_particles()
			if p.grounded: p.jump_particles()
		states.combat_walk: p.max_speed = p.walk_speed
		states.combat_downthrust, states.combat_jump_charge, states.combat_jump_fall:
			p.velocity.x = 0
			if state == states.combat_jump_charge:
				p.combat_jump_multiplier += 0.01
		states.combat_quick1, states.combat_quick2, states.combat_quick3: p.velocity.x = 0
