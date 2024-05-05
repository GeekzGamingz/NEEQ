#Inherits CharacterBody2D Code
extends CharacterBody2D
class_name Kinematic
#-------------------------------------------------------------------------------------------------#
#Constants
const FACING_LEFT: int = -1
const FACING_RIGHT: int = 1
#-------------------------------------------------------------------------------------------------#
#Variables
var facing: Vector2 = Vector2(FACING_RIGHT, 1)
#Movement Variables
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var min_jump_velocity: float = 0.0
var max_jump_velocity: float = 0.0
#Exported Variables
@export var speed: float = 3.5
@export var jump_strength: float = 0.5
@export var jump_duration: float = 0.5
#OnReady Variables
@onready var p = get_parent()
@onready var walk_speed: float = speed * G.TILE_SIZE
@onready var run_speed: float = walk_speed * 2
@onready var max_speed: float = walk_speed
@onready var min_jump_height: float = jump_strength * G.TILE_SIZE
@onready var max_jump_height: float = min_jump_height * 5
#------------------------------------------------------------------------------#
#Applies Gravity
func apply_gravity(delta) -> void:
	velocity.y += gravity * delta
	velocity.x += G.WIND * delta
#------------------------------------------------------------------------------#
#Set Facing
func set_facing(hor_facing) -> void:
	if hor_facing == 0:
		hor_facing = FACING_RIGHT
	var hor_face_mod = hor_facing / abs(hor_facing)
	$Facing.apply_scale(Vector2(hor_face_mod * facing.x, 1))
	facing = Vector2(hor_face_mod, facing.y)
