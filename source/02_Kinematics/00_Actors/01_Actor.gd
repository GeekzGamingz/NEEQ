#Inherits Kinematic Code
extends Kinematic
class_name Actor
#------------------------------------------------------------------------------#
#Variables
#Bool Variables
var grounded: bool = false
var jumping: bool = false
var wall: bool = false
var ledge: bool = false
#OnReady Variables
#Detector Nodes
@onready var world_detectors: Node2D = $Facing/WorldDetectors
#Ground Detectors
@onready var groundDetectors: Node2D = world_detectors.get_node("GroundDetectors")
@onready var safe_fall: RayCast2D = world_detectors.get_node("SafeFallDetector")
#Wall Detectors
@onready var wall_detectors: Node2D = world_detectors.get_node("WallDetectors")
@onready var wall_detector1: RayCast2D = wall_detectors.get_node("WallDetector1")
@onready var wall_detector2: RayCast2D = wall_detectors.get_node("WallDetector2")
@onready var ledge_detector: RayCast2D = wall_detectors.get_node("LedgeDetector")
#Animation Nodes
@onready var sprite_player: AnimationPlayer = $AnimationPlayers/SpritePlayer
@onready var anim_tree: AnimationTree = $AnimationPlayers/AnimationTree
@onready var playback = anim_tree.get("parameters/playback")
@onready var pb_state = playback.get_current_node()
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	anim_tree.active = true #Active Animation Tree
	gravity = 2 * max_jump_height / pow(jump_duration, 2) #Redefine Gravity
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height) #Min Jump
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height) #Max Jump
#------------------------------------------------------------------------------#
#World Detection
#Ground Detection
func check_grounded() -> bool:
	for groundDetector in groundDetectors.get_children():
		if groundDetector.is_colliding(): return true
	return false
#Wall Detection
func check_wall() -> bool:
	if (wall_detector2.is_colliding() &&
		ledge_detector.is_colliding() &&
		!safe_fall.is_colliding()): return true
	return false
#Ledge Detection
func check_ledge() -> bool:
	if (!ledge_detector.is_colliding() &&
		 wall_detector1.is_colliding() &&
		!safe_fall.is_colliding()): return true
	return false
#------------------------------------------------------------------------------#
