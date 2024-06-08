#Inherits CharacterBody2D Code
extends CharacterBody2D
class_name OW_Kinematic
#------------------------------------------------------------------------------#
#Variables
var grid_direction: Vector2 = Vector2.ZERO
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
#Bool Variables
var moving: bool = false
#Exported Variables
@export var speed: float = 0.35
@export var delay: float = 0.1
#OnReady Variables
@onready var move_detector: RayCast2D = $MoveDetector
@onready var anim_player: AnimationPlayer = $AnimationPlayers/AnimationPlayer
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	move_detector.target_position = Vector2.DOWN * (float(G.TILE_SIZE_OW) / 2)
#------------------------------------------------------------------------------#
#Apply Movement
func apply_movement(dir: Vector2) -> void:
	if grid_direction.length() == 0 && dir.length() > 0:
		var movement = Vector2.DOWN
		if dir.y > 0: movement = Vector2.DOWN
		elif dir.y < 0: movement = Vector2.UP
		elif dir.x > 0: movement = Vector2.RIGHT
		elif dir.x < 0: movement = Vector2.LEFT
		#Update Raycast
		move_detector.target_position = movement * (float(G.TILE_SIZE_OW) / 2)
		move_detector.force_raycast_update()
		if !move_detector.is_colliding():
			grid_direction = movement
			var new_position = global_position + (grid_direction * G.TILE_SIZE_OW)
			#Tween Position
			var tween = create_tween()
			tween.tween_property(self, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
			#Tween Callbacks
			tween.tween_callback(func(): grid_direction = Vector2.ZERO).set_delay(delay)
			tween.tween_callback(func(): moving = false)
