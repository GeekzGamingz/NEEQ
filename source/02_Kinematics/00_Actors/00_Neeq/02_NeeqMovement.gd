#Inherits Actor Code
extends Actor
class_name NeeqMovement
#------------------------------------------------------------------------------#
#Constants
const FX_JUMP = preload("res://source/03_Objects/01_Particles/00_DustParticles/FX_Jump.tscn")
#------------------------------------------------------------------------------#
#Variables
var direction: float = 0
var dir_prev: float = 0
var dir_new: float = 0
#Bool Variables
var controllable: bool = true
#OnReady Variables
@onready var particles_marker = $Facing/Markers/ParticlesMarker
#Timers
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var ledge_timer: Timer = $Timers/LedgeTimer
@onready var skid_timer: Timer = $Timers/SkidTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
#------------------------------------------------------------------------------#
#Player Movement
func apply_movement() -> void:
	var was_on_floor = grounded
	grounded = check_grounded()
	ledge = check_ledge()
	wall = check_wall()
	if ledge: velocity.y = 0.0
	if wall && !ledge:
		velocity.x = 0.0
		velocity.y = max_speed
	if !grounded && was_on_floor: coyote_timer.start()
	if ledge_timer.is_stopped():
		ledge_detector.enabled = true
		wall_detector1.enabled = true
	move_and_slide()
#Move Direction
func move_direction() -> void:
	dir_prev = direction
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir_new = direction
#Movement Handler
func handle_movement() -> void:
	velocity.x = lerp(velocity.x, float(max_speed * direction), weight())
	if direction > 0: set_facing(FACING_RIGHT)
	elif direction < 0: set_facing(FACING_LEFT)
#------------------------------------------------------------------------------#
#Player Weight
func weight() -> float:
	#Ground Weight
	if grounded || !coyote_timer.is_stopped():
		if direction == 0: return 0.15 #Slow-to-Stop
		elif velocity.x != 0 && max_speed == run_speed: return 0.05 #Running
		else: return 0.2 #Walking
	#Air Weight
	else: return 0.1
#------------------------------------------------------------------------------#
#Ledge Break
func ledge_break() -> void:
	if ledge:
		ledge_timer.start()
		ledge_detector.enabled = false
		wall_detector1.enabled = false
#------------------------------------------------------------------------------#
#Particle Effects
func jump_particles():
	var jump_particle = FX_JUMP.instantiate()
	jump_particle.global_position = particles_marker.global_position
	jump_particle.amount = 3 if max_speed == run_speed || fsm.state == fsm.states.skid else 1
	jump_particle.process_material.gravity.x = -velocity.x / 2
	match(fsm.state):
		fsm.states.wall_slide: jump_particle.lifetime = 0.5
		fsm.states.skid: if max_speed == run_speed:
				jump_particle.process_material.gravity.x = velocity.x / 2
	G.ORPHANS.add_child(jump_particle)
