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
	state_add("interested")
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
		states.idle: 
			if p.facing.x == p.FACING_RIGHT: return states.walk_right
			elif p.facing.x == p.FACING_LEFT: return states.walk_left
		#Walk
		states.walk_left:
			if p.wall_detector1.is_colliding(): return states.walk_right
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_right
			if p.player != null: return states.interested
		states.walk_right:
			if p.wall_detector1.is_colliding(): return states.walk_left
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_left
			if p.player != null: return states.interested
		#Interested
		states.interested:
			if p.player == null: return states.idle
			elif p.player.facing.x == p.facing.x: return states.chase
			elif p.bite_detector.is_colliding(): return states.attack
		#Chase
		states.chase:
			if p.player == null: return states.idle
			elif p.player.facing.x != p.facing.x: return states.interested
			elif p.bite_detector.is_colliding(): return states.attack
		#Attack
		states.attack:
			if p.player == null: return states.interested
			elif !p.bite_detector.is_colliding(): return states.interested
			elif p.atk_timer.is_stopped(): return states.attack
	return null
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
		states.idle: p.playback.travel("idle")
		states.walk_left:
			p.playback.travel("walk")
			p.direction = -1
			p.direction_timer.start()
		states.walk_right:
			p.playback.travel("walk")
			p.direction = 1
			p.direction_timer.start()
		states.interested:
			p.playback.travel ("idle")
			p.direction = 0
			p.play_emote("Question")
		states.chase:
			p.playback.travel("chase")
			p.direction = 1 if p.facing.x == p.FACING_RIGHT else -1
			p.max_speed = p.run_speed
			p.play_emote("Exclaim")
		states.attack:
			p.playback.start("attack")
			p.direction = 0
			p.atk_timer.start()
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.idle: pass
		states.walk_left, states.walk_right:
			p.wall_detector1.enabled = false
			await get_tree().create_timer(0.1).timeout
			p.wall_detector1.enabled = true
		states.chase: p.max_speed = p.walk_speed
