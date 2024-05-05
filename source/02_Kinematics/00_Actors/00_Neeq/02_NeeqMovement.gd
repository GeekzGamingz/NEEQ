#Inherits Actor Code
extends Actor
class_name NeeqMovement
#------------------------------------------------------------------------------#
#Variables
var direction: float = 0
var dir_prev: float = 0
var dir_new: float = 0
#Bool Variables
var controllable: bool = true
#OnReady Variables
#Timers
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var ledge_timer: Timer = $Timers/LedgeTimer
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	anim_tree.active = true #Active Animation Tree
	gravity = 2 * max_jump_height / pow(jump_duration, 2) #Redefine Gravity
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height) #Min Jump
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height) #Max Jump
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
func moveDirection() -> void:
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
#Ledge Jump
func ledge_break() -> void:
	if ledge:
		ledge_timer.start()
		ledge_detector.enabled = false
		wall_detector1.enabled = false