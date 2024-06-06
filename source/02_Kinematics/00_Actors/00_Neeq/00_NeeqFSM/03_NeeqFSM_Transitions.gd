#Inherits StateMachine Code
extends NeeqFSM_Logic
class_name NeeqFSM_Transitions
#------------------------------------------------------------------------------#
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
	#Explorer
		#Idle
		states.idle:
			if p.is_hurting: return states.damage_hit
			if p.MODE == "Combat":
				if Input.is_action_pressed("action_travel"):
					return states.combat_jump_charge_still
				else: return states.combat_idle
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
				elif p.velocity.y > 0: return states.fall
			elif p.velocity.x != 0:
				if p.max_speed == p.walk_speed: return states.walk
				elif p.max_speed == p.run_speed: return states.run
		#Walk & Run
		states.walk, states.run:
			if p.is_hurting: return states.damage_hit
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.MODE == "Combat":
				if Input.is_action_pressed("action_travel"):
					return states.combat_jump_charge_still
				else: return states.combat_idle
			if Input.is_action_just_released("action_quick"): return states.skid
			if (p.dir_prev > p.dir_new || p.dir_prev < p.dir_new):
				if p.max_speed == p.run_speed:
					if p.skid_timer.is_stopped(): return states.skid
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
				elif p.velocity.y > 0: return states.fall
			if p.velocity.x != 0:
				if Input.is_action_just_pressed("action_cancel"): return states.dodge
				elif p.max_speed == p.walk_speed: return states.walk
				elif p.max_speed == p.run_speed:
					if p.MODE == "Combat": return states.combat_quick1
					else: return states.run
			elif p.velocity.x == 0: return states.idle
		states.skid: return states.idle
		#Jumping
		states.jump, states.wall_jump, states.ledge_jump:
			if p.is_hurting: return states.damage_air
			if state != states.wall_jump:
				if Input.is_action_just_pressed("action_cancel"): return states.dodge_air
			if p.wall: return states.wall_slide
			elif p.ledge: return states.ledge
			elif p.grounded: return states.idle
			elif p.velocity.y >= 0: return states.fall
		#Falling
		states.fall: 
			if p.is_hurting: return states.damage_air
			if Input.is_action_just_pressed("action_cancel"): return states.dodge_air
			if p.wall: return states.wall_slide
			elif p.ledge: return states.ledge
			elif p.grounded: return states.idle
			elif p.MODE == "Combat": return states.combat_downthrust
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
		#Dodge
		states.dodge: if p.quick_attack_timer.is_stopped(): return states.run
		states.dodge_air: if p.quick_attack_timer.is_stopped(): return states.fall
		#Wall Slide
		states.wall_slide, states.wall_slide_quick:
			if p.is_hurting: return states.damage_air
			if p.grounded: return states.idle
			elif !p.grounded: if p.velocity.y < 0: return states.wall_jump
			elif !p.wall: return states.fall
			if state == states.wall_slide:
				if p.max_speed == p.run_speed: return states.wall_slide_quick
			elif state == states.wall_slide_quick:
				if p.max_speed == p.walk_speed: return states.wall_slide
		#Ledge
		states.ledge:
			if p.is_hurting: return states.damage_air
			if !p.grounded: if p.velocity.y < 0: return states.ledge_jump
			if p.wall: return states.wall_slide
			elif !p.wall && !p.ledge: return states.fall
	#Combat
		#Combat Idle
		states.combat_idle:
			if p.is_hurting: return states.damage_hit
			if p.MODE == "Explorer": return states.idle
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if Input.is_action_just_pressed("action_quick"):
				if p.MODE == "Explorer": return states.run
				return states.combat_quick1
			elif p.velocity.x != 0: return states.combat_walk
			if Input.is_action_just_pressed("action_travel"):
				return states.combat_jump_charge_still
			if Input.is_action_just_pressed("action_interact"):
				return states.combat_strong1
		#Combat Walk
		states.combat_walk:
			if p.is_hurting: return states.damage_hit
			if p.MODE == "Explorer": return states.walk
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if Input.is_action_just_pressed("action_quick"): return states.combat_quick1
			if Input.is_action_just_pressed("action_travel"): return states.combat_jump_charge_still
			if Input.is_action_just_pressed("action_interact"): return states.combat_strong1
			if p.velocity.x == 0: return states.combat_idle
		#Combat Down Thrust
		states.combat_downthrust:
			if p.is_hurting: return states.damage_air
			if p.wall: return states.wall_slide
			elif p.ledge: return states.ledge
			elif p.grounded: return states.idle
		#Combat Jump
		states.combat_jump_charge_still:
			if p.is_hurting: return states.damage_hit
			if p.direction != 0: return states.combat_jump_charge_inch
			if Input.is_action_just_released("action_travel"): return states.combat_jump_fall
		states.combat_jump_charge_inch:
			if p.is_hurting: return states.damage_hit
			if p.direction == 0: return states.combat_jump_charge_still
			if Input.is_action_just_released("action_travel"): return states.combat_jump_fall
		states.combat_jump_fall:
			if p.is_hurting: return states.damage_air
			if p.quick_attack_timer.is_stopped() && p.grounded:
				if Input.is_action_pressed("action_travel"): return states.combat_jump_charge_still
				else: return states.combat_idle
			if p.ledge: return states.ledge
		#Combat Quick Attack
		states.combat_quick1:
			if p.is_hurting: return states.damage_hit
			if !p.grounded: return states.combat_downthrust
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.quick_attack_timer.is_stopped():
				if p.last_action == "Quick":
					if p.MODE == "Explorer": return states.run
					else: return states.combat_quick2
				elif p.last_action == "Interact":
					return states.combat_strong1
				else: return states.combat_idle
			if Input.get_action_strength("action_travel") > 0:
				return states.combat_jump_charge_still
		states.combat_quick2:
			if p.is_hurting: return states.damage_hit
			if !p.grounded: return states.combat_downthrust
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.quick_attack_timer.is_stopped():
				if p.last_action == "Quick":
					if p.MODE == "Explorer": return states.run
					else: return states.combat_quick3
				elif p.last_action == "Interact":
					return states.combat_strong2
				else: return states.combat_idle
			if Input.get_action_strength("action_travel") > 0:
				return states.combat_jump_charge_still
		states.combat_quick3:
			if p.is_hurting: return states.damage_hit
			if !p.grounded: return states.combat_downthrust
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.quick_attack_timer.is_stopped():
				if p.last_action == "Quick":
					if p.MODE == "Explorer": return states.run
					else: return states.combat_quick1 #Replace With Quick Finisher
				elif p.last_action == "Interact":
					return states.combat_strong3
				else: return states.combat_idle
			if Input.get_action_strength("action_travel") > 0:
				return states.combat_jump_charge_still
		#Combat Strong Attack
		states.combat_strong1:
			if p.is_hurting: return states.damage_hit
			if !p.grounded: return states.combat_downthrust
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.strong_attack_timer.is_stopped():
				if p.last_action == "Quick":
					if p.MODE == "Explorer": return states.run
					else: return states.combat_quick1
				elif p.last_action == "Interact":
					return states.combat_strong2
				else: return states.combat_idle
			if Input.get_action_strength("action_travel") > 0:
				return states.combat_jump_charge_still
		states.combat_strong2:
			if p.is_hurting: return states.damage_hit
			if !p.grounded: return states.combat_downthrust
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.strong_attack_timer.is_stopped():
				if p.last_action == "Quick":
					if p.MODE == "Explorer": return states.run
					else: return states.combat_quick2
				elif p.last_action == "Interact":
					return states.combat_strong3
				else: return states.combat_idle
			if Input.get_action_strength("action_travel") > 0:
				return states.combat_jump_charge_still
		states.combat_strong3:
			if p.is_hurting: return states.damage_hit
			if !p.grounded: return states.combat_downthrust
			if Input.is_action_just_pressed("action_cancel"): return states.dodge
			if p.strong_attack_timer.is_stopped():
				if p.last_action == "Quick":
					if p.MODE == "Explorer": return states.run
					else: return states.combat_quick3
				elif p.last_action == "Interact":
					return states.combat_strong1 #Replace With Strong Finisher
				else: return states.combat_idle
			if Input.get_action_strength("action_travel") > 0:
				return states.combat_jump_charge_still
	#Damage
		states.damage_hit, states.damage_air:
			if p.damage_timer.is_stopped():
				if p.is_dead: return states.damage_death
				else: return states.idle
		states.damage_death: pass
	return null
