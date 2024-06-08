#Inherits Kinematic Code
extends Kinematic
class_name Actor
#------------------------------------------------------------------------------#
#Constants
const EMOTES: PackedScene = preload("res://source/05_UserInterface/01_Emotes/_Emotes.tscn")
#------------------------------------------------------------------------------#
#Variables
#Bool Variables
var grounded: bool = false
var jumping: bool = false
var wall: bool = false
var ledge: bool = false
#OnReady Variables
@onready var fsm: Node2D = get_child(0)
#Emotes
@onready var emotes_marker: Marker2D = $Facing/Markers/EmotesMarker
@onready var emote_timer: Timer = $Timers/EmoteTimer
#Detector Nodes
@onready var world_detectors: Node2D = $Facing/WorldDetectors
#Ground Detectors
@onready var ground_detectors: Node2D = world_detectors.get_node("GroundDetectors")
@onready var ground_detector1: RayCast2D = ground_detectors.get_node("GroundDetector1")
@onready var ground_detector2: RayCast2D = ground_detectors.get_node("GroundDetector2")
@onready var ground_detector3: RayCast2D = ground_detectors.get_node("GroundDetector3")
@onready var safe_fall: RayCast2D = world_detectors.get_node("SafeFallDetector")
#Wall Detectors
@onready var wall_detectors: Node2D = world_detectors.get_node("WallDetectors")
@onready var wall_detector1: RayCast2D = wall_detectors.get_node("WallDetector1")
@onready var wall_detector2: RayCast2D = wall_detectors.get_node("WallDetector2")
@onready var ledge_detector: RayCast2D = wall_detectors.get_node("LedgeDetector")
#Animation Nodes
@onready var sprite_player: AnimationPlayer = $AnimationPlayers/SpritePlayer
@onready var anim_tree: AnimationTree = $AnimationPlayers/AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
@onready var pb_state: String = playback.get_current_node()
#Audio Nodes
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayers/AudioPlayer
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
	for detector in ground_detectors.get_children():
		if detector.is_colliding(): return true
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
#Emote
func play_emote(emote: String):
	if emote_timer.is_stopped():
		emote_timer.start()
		var emote_scene = EMOTES.instantiate()
		emote_scene.position = emotes_marker.position
		emote_scene.emote = emote
		add_child(emote_scene)
		if facing.x == FACING_LEFT:
			emote_scene.position.x = -emotes_marker.position.x
			emote_scene.chat_bubble.flip_h = true
