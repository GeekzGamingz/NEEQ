#Inherits StateMachine Code
extends NeeqFSM_Input
class_name NeeqFSM_Logic
#------------------------------------------------------------------------------#
#State Logistics
func state_logic(delta):
	p.handle_mode()
	p.move_direction()
	p.update_last_action()
	p.grapple_rotation()
	if ![states.wall_slide, states.wall_slide_quick, states.wall_jump,
		states.ledge, states.combat_downthrust, states.combat_jump_fall,
		states.damage_hit, states.damage_air, states.damage_death].has(state):
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
		states.combat_downthrust, states.combat_jump_fall: p.velocity.x = 0
		states.combat_jump_charge_still, states.combat_jump_charge_inch:
			p.velocity.x = 0
			p.combat_jump_multiplier += p.charge_strength
		states.combat_quick1, states.combat_quick2, states.combat_quick3: p.velocity.x = 0
		states.combat_strong1, states.combat_strong2, states.combat_strong3: p.velocity.x = 0
		states.damage_hit, states.damage_air:
			if p.facing.x == p.FACING_RIGHT: p.velocity.x = -G.TILE_SIZE
			else: p.velocity.x = G.TILE_SIZE
		states.damage_death: p.velocity.x = 0
		states.grapple_hooked: p.velocity = Vector2.ZERO
