#Inherits StateMachine Code
extends NeeqFSM_Transitions
class_name NeeqFSM_Presence
#-------------------------------------------------------------------------------------------------#
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
		states.idle: p.playback.travel("idle")
		states.walk: p.playback.travel("walk")
		states.run: p.playback.travel("run")
		states.skid: p.playback.start("skid")
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
		states.wall_slide:
			p.playback.start("wall_slide")
			p.safe_fall.enabled = false
		states.fall:
			p.playback.start("jump_fall")
			p.jumping = true if p.coyote_timer.is_stopped() else false
			p.wall_detector2.enabled = true
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.wall_slide: p.safe_fall.enabled = true
		states.fall: p.jumping = false
