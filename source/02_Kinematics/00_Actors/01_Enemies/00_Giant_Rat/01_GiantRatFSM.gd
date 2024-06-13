#Inherits StateMachine Code
extends StateMachine
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p: Node2D = get_parent()
@onready var state_label: Label = p.get_node("Outputs/StateOutput")
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	state_add("idle")
	state_add("walk_left")
	state_add("walk_right")
	state_add("interested")
	state_add("chase")
	state_add("attack")
	state_add("hit")
	state_add("death")
	call_deferred("state_set", states.idle)
#------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	state_label.text = str(states.keys()[state])
#------------------------------------------------------------------------------#
#State Machine
#State Logistics
func state_logic(delta):
	p.handle_movement()
	p.apply_gravity(delta)
	p.apply_movement()
	match(state):
		states.idle: pass
		states.hit:
			if p.facing.x == p.FACING_RIGHT: p.velocity.x = -G.TILE_SIZE
			else: p.velocity.x = G.TILE_SIZE
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
		#Idle
		states.idle:
			if p.is_hurting: return states.hit 
			if p.facing.x == p.FACING_RIGHT: return states.walk_right
			elif p.facing.x == p.FACING_LEFT: return states.walk_left
		#Walk
		states.walk_left:
			if p.is_hurting: return states.hit
			if p.wall_detector1.is_colliding(): return states.walk_right
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_right
			if p.player != null: return states.interested
		states.walk_right:
			if p.is_hurting: return states.hit
			if p.wall_detector1.is_colliding(): return states.walk_left
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_left
			if p.player != null: return states.interested
		#Interested
		states.interested:
			if p.is_hurting: return states.hit
			if p.player == null: return states.idle
			elif p.player.MODE == "Combat": return states.chase
			elif p.player.facing.x == p.facing.x: return states.chase
			elif p.bite_detector.is_colliding(): return states.attack
		#Chase
		states.chase:
			if p.is_hurting: return states.hit
			if p.player == null: return states.idle
			elif p.player.facing.x != p.facing.x:
				if p.player.MODE != "Combat": return states.interested
			if p.bite_detector.is_colliding(): return states.attack
		#Attack
		states.attack:
			if p.is_hurting: return states.hit
			if p.player == null: return states.interested
			elif !p.bite_detector.is_colliding(): return states.interested
			elif p.atk_timer.is_stopped(): return states.attack
		#Hit
		states.hit:
			if p.damage_timer.is_stopped():
				if p.is_dead: return states.death
				else: return states.idle
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
			if p.player.facing.x == p.facing.x: p.play_emote("Exclaim")
			elif p.player.MODE == "Combat": p.play_emote("Exclaim")
			else: p.play_emote("Question")
		states.chase:
			p.playback.travel("chase")
			p.direction = 1 if p.facing.x == p.FACING_RIGHT else -1
			p.max_speed = p.run_speed
			p.play_emote("Exclaim")
		states.attack:
			p.playback.start("attack")
			p.direction = 0
			p.atk_timer.start()
		states.hit:
			p.damage_timer.start()
			p.playback.start("hit")
		states.death:
			p.playback.start("death")
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
		states.hit:
			if p.player == null: p.direction = -p.direction
			p.is_hurting = false
