#Inherits Actor Code
extends Actor
#-------------------------------------------------------------------------------------------------#

#Variables
var direction = 0
var dir_prev = 0
var dir_new = 0
#Bool Variables
var grounded = false
var jumping = false
var wall = false
var ledge = false
var skidding = false
#OnReady Variables
#Detectors
@onready var wallDetectors = $Facing/WorldDetectors/WallDetectors
@onready var wallDetector1 = $Facing/WorldDetectors/WallDetectors/WallDetector1
@onready var wallDetector2 = $Facing/WorldDetectors/WallDetectors/WallDetector2
@onready var ledgeDetector = $Facing/WorldDetectors/WallDetectors/LedgeDetector
@onready var groundDetectors = $Facing/WorldDetectors/GroundDetectors
@onready var safeFall = $Facing/WorldDetectors/SafeFallDetector
#Animation Nodes
#@onready var spritePlayer = $AnimationPlayers/SpritePlayer
#@onready var animTree = $AnimationPlayers/AnimationTree
#@onready var playBack = animTree.get("parameters/playback")
#@onready var currentState = playBack.get_current_node()
#Timers
@onready var coyoteTimer = $Timers/CoyoteTimer
@onready var ledgeTimer = $Timers/LedgeTimer
#-------------------------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
#-------------------------------------------------------------------------------------------------#
#Applies Gravity
func apply_gravity(delta):
	velocity.y += gravity * delta
#-------------------------------------------------------------------------------------------------#
#Player Movement
func apply_movement():
	if velocity.y >= 0:
		wallDetector2.enabled = true
	var was_on_floor = grounded
	grounded = check_grounded()
	ledge = check_ledge()
	wall = check_wall()
	if ledge:
		velocity.y = 0.0
	if wall && !ledge:
		velocity.x = 0.0
		velocity.y = walk_speed
	#velocity = move_and_slide(velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	move_and_slide()
	if !grounded && was_on_floor:
		coyoteTimer.start()
	if ledgeTimer.is_stopped():
		ledgeDetector.enabled = true
		wallDetector1.enabled = true
	if grounded || ledge || wall:
		jumping = false
#-------------------------------------------------------------------------------------------------#
#Move Direction
func moveDirection():
	dir_prev = direction
	direction = (int(Input.is_action_pressed("move_right")) -
				 int(Input.is_action_pressed("move_left")))
	dir_new = direction
#-------------------------------------------------------------------------------------------------#
#Movement Handler
func handle_movement():
	velocity.x = lerp(velocity.x, float(max_speed * direction), weight())
	if direction > 0:
		set_facing(FACING_RIGHT)
	elif direction < 0:
		set_facing(FACING_LEFT)
	if Input.is_action_pressed("action_run"):
		max_speed = run_speed
	if Input.is_action_just_released("action_run"):
		max_speed = walk_speed
		if grounded && !ledge && velocity.x != 0:
			skidding = true
	if (((dir_prev > dir_new) || (dir_prev < dir_new)) && dir_prev != 0 &&
		  max_speed == run_speed && grounded && !ledge):
			skidding = true
#-------------------------------------------------------------------------------------------------#
#Ledge Jump
func ledgeBreak():
	if ledge:
		ledgeTimer.start()
		ledgeDetector.enabled = false
		wallDetector1.enabled = false
#-------------------------------------------------------------------------------------------------#
#Player Weight
func weight():
	#Ground Weight
	if (grounded) || (!coyoteTimer.is_stopped()):
		#Slow-to-Stop
		if (!Input.is_action_pressed("move_right") &&
			!Input.is_action_pressed("move_left")):
			return 0.15
		#Running
		elif velocity.x != 0 && max_speed == run_speed:
			return 0.05
		#Walking
		else:
			return 0.2
	#Air Weight
	else:
		return 0.1
#-------------------------------------------------------------------------------------------------#
#World Detection
#Ground Detection
func check_grounded():
	for groundDetector in groundDetectors.get_children():
		if groundDetector.is_colliding():
			return true
	return false
#Wall Detection
func check_wall():
	if (wallDetector2.is_colliding() &&
		ledgeDetector.is_colliding() &&
		!safeFall.is_colliding()):
			return true
	return false
#Ledge Detection
func check_ledge():
	if (!ledgeDetector.is_colliding() &&
		 wallDetector1.is_colliding() &&
		!safeFall.is_colliding()):
			return true
	return false
#-------------------------------------------------------------------------------------------------#
#Enemy Detection
func _on_Neeq_HitBox_area_entered(area: Area2D) -> void:
	var attack = area.name
	match(attack):
		"LightAttack": print("1 DMG")
		"MediumAttack": print("2 DMG")
		"ModerateAttack": print("3 DMG")
		"StrongAttack": print("4 DMG")
		"EliteAttack": print ("5 DMG")
