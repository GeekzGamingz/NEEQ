#Inherits StateMachine Code
extends NeeqFSM_Logic
class_name NeeqFSM_Transitions
#-------------------------------------------------------------------------------------------------#
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
	#Explorer
		#Idle
		states.idle:
			if p.MODE == "Combat": return states.combat_idle
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
				elif p.velocity.y > 0: return states.fall
			elif p.velocity.x != 0:
				if p.max_speed == p.walk_speed: return states.walk
				elif p.max_speed == p.run_speed: return states.run
		#Walk & Run
		states.walk, states.run:
			if p.MODE == "Combat": return states.combat_idle
			if Input.is_action_just_released("action_quick"): return states.skid
			if (p.dir_prev > p.dir_new || p.dir_prev < p.dir_new):
				if p.max_speed == p.run_speed:
					if p.skid_timer.is_stopped(): return states.skid
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
				elif p.velocity.y > 0: return states.fall
			if p.velocity.x != 0:
				if p.max_speed == p.walk_speed: return states.walk
				elif p.max_speed == p.run_speed:
					if p.MODE == "Combat": return states.combat_quick1
					else: return states.run
			elif p.velocity.x == 0: return states.idle
		states.skid: return states.idle
		#Jumping
		states.jump, states.wall_jump, states.ledge_jump: 
			if p.wall: return states.wall_slide
			elif p.ledge: return states.ledge
			elif p.grounded: return states.idle
			elif p.velocity.y >= 0: return states.fall
		#Falling
		states.fall: 
			if p.wall: return states.wall_slide
			elif p.ledge: return states.ledge
			elif p.grounded: return states.idle
			elif p.MODE == "Combat": return states.combat_thrust
		#Wall Slide
		states.wall_slide, states.wall_slide_quick:
			if p.grounded: return states.idle
			elif !p.grounded: if p.velocity.y < 0: return states.wall_jump
			elif !p.wall: return states.fall
			if states.wall_slide:
				if p.max_speed == p.run_speed: return states.wall_slide_quick
			elif states.wall_slide_quick:
				if p.max_speed == p.walk_speed: return states.wall_slide
		#Ledge
		states.ledge:
			if !p.grounded: if p.velocity.y < 0: return states.ledge_jump
			if p.wall: return states.wall_slide
			elif !p.wall && !p.ledge: return states.fall
	#Combat
		#Combat Idle
		states.combat_idle:
			if p.MODE == "Explorer": return states.idle
			if Input.get_action_strength("action_quick") > 0:
				if p.MODE == "Explorer": return states.run
				return states.combat_quick1
		#Combat Strike
		states.combat_quick1:
			if Input.get_action_strength("action_quick") > 0:
				if p.MODE == "Explorer": return states.run
				if p.attack_timer.is_stopped(): return states.combat_quick2
			elif p.attack_timer.is_stopped(): return states.combat_idle
		states.combat_quick2:
			if Input.get_action_strength("action_quick") > 0:
				if p.MODE == "Explorer": return states.run
				if p.attack_timer.is_stopped(): return states.combat_quick3
			elif p.attack_timer.is_stopped(): return states.combat_idle
		states.combat_quick3:
			if Input.get_action_strength("action_quick") > 0:
				if p.MODE == "Explorer": return states.run
				if p.attack_timer.is_stopped(): return states.combat_quick1
			elif p.attack_timer.is_stopped(): return states.combat_idle
		states.combat_thrust:
			if p.wall: return states.wall_slide
			elif p.ledge: return states.ledge
			elif p.grounded: return states.idle
	return null
