#Inherits OW_Kinematic Coce
extends OW_Kinematic
#------------------------------------------------------------------------------#
#Variables
var direction: Vector2 = Vector2.ZERO
#Bool Variables
var controllable: bool = true
#------------------------------------------------------------------------------#
#Ready Function
func _ready() -> void:
	#Snap to Grid
	position = position.snapped(Vector2.ONE * G.TILE_SIZE_OW)
	position -= Vector2.ONE * (float(G.TILE_SIZE_OW) / 2)
#------------------------------------------------------------------------------#
#Player Direction
func move_direction():
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"))
