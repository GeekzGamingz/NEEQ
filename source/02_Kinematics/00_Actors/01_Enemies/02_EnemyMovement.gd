#Inherits Actor Code
extends Actor
class_name EnemyMovement
#------------------------------------------------------------------------------#
#Variables
var dir_prev: float = 0
var dir_new: float = 0
#Exported Variables
@export var direction: float = 0
#Bool Variables
#OnReady Variables
#------------------------------------------------------------------------------#
#Player Movement
func apply_movement() -> void:
	grounded = check_grounded()
	ledge = check_ledge()
	wall = check_wall()
	if ledge: velocity.y = 0.0
	if wall && !ledge:
		velocity.x = 0.0
		velocity.y = max_speed
	move_and_slide()
#Move Direction
func swap_direction() -> void:
	dir_prev = direction
	direction *= -1
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
	if grounded:
		if direction == 0: return 0.15 #Slow-to-Stop
		elif velocity.x != 0 && max_speed == run_speed: return 0.05 #Running
		else: return 0.2 #Walking
	#Air Weight
	else: return 0.1
#------------------------------------------------------------------------------#
#Ledge Jump
func ledge_break() -> void:
	if ledge:
		ledge_detector.enabled = false
		wall_detector1.enabled = false
