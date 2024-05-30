#Inherits StateMachine Code
extends StateMachine
class_name NeeqFSM_Input
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p = get_parent()
@onready var state_label: Label = p.get_node("Outputs/StateOutput")
@onready var mode_label: Label = p.get_node("Outputs/ModeOutput")
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	#Update Debug
	G.DEBUG.player = p
	#Add States
	#Explorer
	state_add("idle")
	state_add("walk")
	state_add("run")
	state_add("jump")
	state_add("fall")
	state_add("ledge")
	state_add("ledge_jump")
	state_add("wall_slide")
	state_add("wall_slide_quick")
	state_add("wall_jump")
	state_add("skid")
	state_add("dodge")
	state_add("dodge_air")
	#Combat
	state_add("combat_idle")
	state_add("combat_walk")
	state_add("combat_quick1")
	state_add("combat_quick2")
	state_add("combat_quick3")
	state_add("combat_strong1")
	state_add("combat_strong2")
	state_add("combat_strong3")
	state_add("combat_downthrust")
	state_add("combat_jump_charge")
	state_add("combat_jump_fall")
	#Damage
	state_add("damage_hit")
	state_add("damage_air")
	state_add("damage_death")
	#Call Deferred
	call_deferred("state_set", states.idle)
#------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	state_label.text = str(states.keys()[state])
	mode_label.text = str(p.MODE)
#------------------------------------------------------------------------------#
#Input Handler
func _input(event: InputEvent) -> void:
	#Horizontal Movement
	if event.is_action_pressed("action_quick"): p.max_speed = p.run_speed
	elif event.is_action_released("action_quick"): p.max_speed = p.walk_speed
	#Verticle Movement
	if [states.idle, states.walk, states.run, states.ledge,
		states.wall_slide, states.wall_slide_quick, states.fall].has(state):
		if !p.jumping:
			if event.is_action_pressed("action_travel"):
				p.jump_particles()
				if p.grounded || p.ledge || !p.coyote_timer.is_stopped():
					p.coyote_timer.stop()
					if states.ledge: p.ledge_break()
				elif state == states.wall_slide || state == states.wall_slide_quick:
					p.velocity.x = -p.max_speed if p.facing.x == p.FACING_RIGHT else p.max_speed
					if p.facing.x == p.FACING_RIGHT: p.set_facing(p.FACING_LEFT)
					elif p.facing.x == p.FACING_LEFT: p.set_facing(p.FACING_RIGHT)
				p.velocity.y = p.max_jump_velocity
				p.wall_detector2.enabled = false
	if [states.jump, states.wall_jump, states.ledge_jump].has(state):
	#Verticle Interrupt
		if event.is_action_released("action_travel") && p.velocity.y < p.min_jump_velocity:
			p.velocity.y = p.min_jump_velocity
	#Slide From Ledge
	if states.ledge: if event.is_action_pressed("move_down"): p.ledge_break()
