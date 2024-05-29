#Inherits StateMachine Code
extends StateMachine
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p = get_parent()
@onready var state_label: Label = p.get_node("Outputs/StateOutput")
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	state_add("idle")
	state_add("walk_north")
	state_add("walk_south")
	state_add("walk_west")
	state_add("walk_east")
	call_deferred("state_set", states.idle)
#------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	state_label.text = str(states.keys()[state])
#------------------------------------------------------------------------------#
#State Machine
#State Logistics
func state_logic(_delta):
	p.move_direction()
	p.apply_movement(p.direction)
	match(state):
		states.idle: pass
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
		#Idle
		states.idle: return map_move()
		#Walk
		states.walk_north: return map_move()
		states.walk_south: return map_move()
		states.walk_west: return map_move()
		states.walk_east: return map_move()
	return null
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
		states.idle: p.anim_player.play("idle")
		states.walk_north:
			p.anim_player.play("walk_north")
			p.moving = true
		states.walk_south:
			p.anim_player.play("walk_south")
			p.moving = true
		states.walk_west:
			p.anim_player.play("walk_west")
			p.moving = true
		states.walk_east:
			p.anim_player.play("walk_east")
			p.moving = true
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.idle: pass
#------------------------------------------------------------------------------#
func map_move():
	if p.grid_direction != Vector2.ZERO && !p.moving:
		if p.encounter_timer.is_stopped(): p.encounters.random_encounter()
		if p.direction.y < 0: return states.walk_north
		elif p.direction.y > 0: return states.walk_south
		elif p.direction.x < 0: return states.walk_west
		elif p.direction.x > 0: return states.walk_east
	elif p.grid_direction == Vector2.ZERO: return states.idle
