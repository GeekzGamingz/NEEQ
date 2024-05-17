#Inherits StateMachine Code
extends NeeqFSM_Transitions
class_name NeeqFSM_Presence
#-------------------------------------------------------------------------------------------------#
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
	#Explorer Mode
		states.idle: p.playback.travel("idle")
		states.walk: p.playback.travel("walk")
		states.run: p.playback.travel("run")
		states.skid:
			p.playback.start("skid")
			p.particles_marker.position = Vector2(10, 0)
		states.jump:
			p.playback.start("jump_takeoff")
			p.jumping = true
		states.wall_jump:
			p.playback.start("wall_jump")
			p.jumping = true
		states.ledge_jump:
			p.playback.start("jump_ledge")
			p.jumping = true
		states.ledge:
			p.playback.start("wall_ledge")
			p.jumping = false
		states.wall_slide, states.wall_slide_quick:
			p.playback.start("wall_slide")
			if states.wall_slide_quick:
				p.playback.travel("wall_slide_quick")
			p.safe_fall.enabled = false
			p.particles_marker.position = Vector2(7, -7)
		states.fall:
			p.playback.start("jump_fall")
			p.wall_detector2.enabled = true
		states.dodge, states.dodge_air:
			p.playback.start("dodge")
			p.attack_timer.start()
			p.particles_marker.position = Vector2(0, -16)
	#Combat Mode
		states.combat_idle: p.playback.travel("combat_idle")
		states.combat_walk: p.playback.travel("combat_walk")
		states.combat_quick1:
			p.playback.start("combat_quick1")
			p.attack_timer.start()
		states.combat_quick2:
			p.playback.start("combat_quick2")
			p.attack_timer.start()
		states.combat_quick3:
			p.playback.start("combat_quick3")
			p.attack_timer.start()
		states.combat_jump_charge: pass #Charge Code
		states.combat_jump_fall:
			await get_tree().create_timer(p.jump_duration).timeout
			p.gravity *= 10.0
		states.combat_downthrust: p.gravity *= 5.0
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	p.particles_marker.position = Vector2.ZERO
	match(old_state):
		states.fall: p.jumping = false
		states.wall_slide, states.wall_slide_quick: p.safe_fall.enabled = true
		states.skid: p.skid_timer.start()
		states.combat_jump_charge:
			p.combat_jump_multiplier = min(p.combat_jump_multiplier, 2)
			p.velocity.y = p.max_jump_velocity * p.combat_jump_multiplier
			p.combat_jump_multiplier = 1.0
			p.attack_timer.start()
		states.combat_jump_fall: p.gravity /= 10.0
		states.combat_downthrust: p.gravity /= 5.0
