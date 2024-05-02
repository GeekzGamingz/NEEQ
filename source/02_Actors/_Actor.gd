#Handles 2D Bodies
extends CharacterBody2D
class_name Actor
#-------------------------------------------------------------------------------------------------#
#Constants
const FACING_RIGHT = 1
const FACING_LEFT = -1
#-------------------------------------------------------------------------------------------------#
#Variables
#Movement
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var walk_speed = 3.5 * G.TILE_SIZE
var run_speed = 7 * G.TILE_SIZE
var max_speed = walk_speed
var min_jump_velocity
var max_jump_velocity
var min_jump_height = 0.5 * G.TILE_SIZE
var max_jump_height = 2.5 * G.TILE_SIZE
var jump_duration = 0.5
var facing = Vector2(FACING_RIGHT, 1)
#OnReady Variables
@onready var p = get_parent()
#-------------------------------------------------------------------------------------------------#
#Set Facing
func set_facing(hor_facing):
	if hor_facing == 0:
		hor_facing = FACING_RIGHT
	var hor_face_mod = hor_facing / abs(hor_facing)
	$Facing.apply_scale(Vector2(hor_face_mod * facing.x, 1))
	facing = Vector2(hor_face_mod, facing.y)
