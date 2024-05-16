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
			p.particles_marker.position = Vector2(-10, 0)
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
			p.jumping = true if p.coyote_timer.is_stopped() else false
			p.wall_detector2.enabled = true
	#Combat Mode
		states.combat_idle: p.playback.travel("combat_idle")
		states.combat_quick1:
			p.playback.start("combat_quick1")
			p.attack_timer.start()
		states.combat_quick2:
			p.playback.start("combat_quick2")
			p.attack_timer.start()
		states.combat_quick3:
			p.playback.start("combat_quick3")
			p.attack_timer.start()
		states.combat_thrust: p.gravity *= 5.0
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.wall_slide, states.wall_slide_quick:
			p.safe_fall.enabled = true
			p.particles_marker.position = Vector2.ZERO
		states.fall: p.jumping = false
		states.skid:
			p.skid_timer.start()
			p.particles_marker.position = Vector2.ZERO
		states.combat_thrust: p.gravity /= 5.0
