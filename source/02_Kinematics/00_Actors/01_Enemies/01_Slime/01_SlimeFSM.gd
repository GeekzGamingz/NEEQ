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
	#Add States
	state_add("idle")
	state_add("walk_left")
	state_add("walk_right")
	state_add("lurking")
	state_add("drip_pool")
	state_add("drip_drop")
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
	if p.MODE == "Lurking": p.reverse_gravity(delta)
	else: p.apply_gravity(delta)
	p.apply_movement()
	match(state):
		states.idle: pass
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
		#Idle
		states.idle: 
			if p.is_dead: return states.death
			if p.MODE == "Lurking": return states.lurking
			if p.facing.x == p.FACING_RIGHT: return states.walk_right
			elif p.facing.x == p.FACING_LEFT: return states.walk_left
		states.lurking:
			if p.is_dead: return states.death
			if p.safe_fall.is_colliding(): return states.drip_pool
		#Walk
		states.walk_left:
			if p.is_dead: return states.death
			if p.wall_detector1.is_colliding(): return states.walk_right
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_right
		states.walk_right:
			if p.is_dead: return states.death
			if p.wall_detector1.is_colliding(): return states.walk_left
			if !p.ground_detector3.is_colliding():
				if p.direction_timer.is_stopped(): return states.walk_left
		#Drip
		states.drip_pool:
			if p.is_dead: return states.death
			if p.is_pooled: return states.drip_drop
		states.drip_drop:
			if p.is_dead: return states.death
			if p.check_grounded(): return states.idle
		#Death
		states.death: pass
	return null
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
		#Idle
		states.idle: 
			p.playback.travel("idle")
		states.lurking:
			p.playback.start("lurking")
			p.set_vert(p.UP_SIDE_DOWN)
		#Walk
		states.walk_left:
			p.playback.travel("walk")
			p.direction = -0.5
			p.direction_timer.start()
		states.walk_right:
			p.playback.travel("walk")
			p.direction = 0.5
			p.direction_timer.start()
		#Drip
		states.drip_pool: p.playback.travel("drip_pool")
		states.drip_drop:
			p.position.y += G.TILE_SIZE / 2.0
			p.playback.start("drip_drop")
			p.set_vert(p.RIGHT_SIDE_UP)
			p.MODE = "Grounded"
		#Death
		states.death: pass
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.idle: pass
