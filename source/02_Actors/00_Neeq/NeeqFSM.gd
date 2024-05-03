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
	state_add("walk")
	state_add("run")
	state_add("jump")
	state_add("fall")
	state_add("ledge")
	state_add("ledge_jump")
	state_add("wall_slide")
	state_add("wall_jump")
	state_add("skid")
	call_deferred("state_set", states.idle)
#-------------------------------------------------------------------------------------------------#
#State Label
func _process(_delta: float) -> void:
	state_label.text = str(states.keys()[state])
#-------------------------------------------------------------------------------------------------#
#Input Handler
func _input(event: InputEvent) -> void:
	if [states.idle, states.walk, states.run, states.ledge,
		states.wall_slide, states.fall].has(state) && !p.jumping:
		#Jumping
		if event.is_action_pressed("action_jump"):
			if p.grounded || p.ledge || !p.coyoteTimer.is_stopped():
				p.coyoteTimer.stop()
				if states.ledge: p.ledge_break()
			elif state == states.wall_slide:
				p.velocity.x = (-p.walk_speed if p.facing.x ==
									p.FACING_RIGHT else p.walk_speed)
			p.velocity.y = p.max_jump_velocity
			p.wall_detector2.enabled = false
	if [states.jump, states.wall_jump, states.ledge_jump].has(state):
	#Jump Interrupt
		if event.is_action_released("action_jump") && p.velocity.y < p.min_jump_velocity:
			p.velocity.y = p.min_jump_velocity
	#Slide From Ledge
	if states.ledge:
		if Input.is_action_pressed("move_down"): p.ledge_break()
#-------------------------------------------------------------------------------------------------#
#State Machine
#State Logistics
func state_logic(delta):
	p.moveDirection()
	if ![states.wall_slide, states.ledge].has(state):
		p.handle_movement()
	p.apply_gravity(delta)
	p.apply_movement()
#State Transitions
@warning_ignore("unused_parameter")
func transitions(delta):
	match(state):
		#Idle
		states.idle:
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
				elif p.velocity.y > 0: return states.fall
			elif p.velocity.x != 0:
				if p.max_speed == p.walk_speed: return states.walk
				elif p.max_speed == p.run_speed: return states.run
		#Walk & Run
		states.walk, states.run, states.skid:
			if !p.grounded:
				if p.velocity.y < 0: return states.jump
				elif p.velocity.y > 0: return states.fall
			if p.velocity.x != 0 && !p.skidding:
				if p.max_speed == p.walk_speed: return states.walk
				elif p.max_speed == p.run_speed: return states.run
			elif p.velocity.x == 0: return states.idle
			elif p.skidding:
				p.skidding = false
				return states.skid
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
		#Wall Slide
		states.wall_slide:
			if p.grounded: return states.idle
			elif !p.grounded: if p.velocity.y < 0: return states.wall_jump
			elif !p.wall: return states.fall
		#Ledge
		states.ledge:
			if !p.grounded: if p.velocity.y < 0: return states.ledge_jump
			if p.wall: return states.wall_slide
			elif !p.wall && !p.ledge: return states.fall
	return null
#Enter State
@warning_ignore("unused_parameter")
func state_enter(new_state, old_state):
	match(new_state):
		states.idle: p.playback.travel("idle")
		states.walk: p.playback.travel("walk")
		states.run: p.playback.travel("run")
		states.skid:
			p.playback.start("skid")
			p.skidding = false
		states.jump:
			p.playback.start("jump_takeoff")
			p.jumping = true
		states.wall_jump:
			p.playback.start("wall_jump")
			p.jumping = true
		states.ledge_jump:
			p.playback.start("jump_ledge")
			p.jumping = true
		states.ledge: p.playback.start("wall_ledge")
		states.wall_slide:
			p.playback.start("wall_slide")
			p.safe_fall.enabled = false
		states.fall:
			p.playback.start("jump_fall")
			p.jumping = true if p.coyoteTimer.is_stopped() else false
#Exit State
@warning_ignore("unused_parameter")
func state_exit(old_state, new_state):
	match(old_state):
		states.wall_slide: p.safe_fall.enabled = true
