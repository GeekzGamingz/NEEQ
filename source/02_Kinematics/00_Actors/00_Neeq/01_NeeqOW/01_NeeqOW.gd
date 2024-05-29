#Inherits OW_Kinematic Coce
extends OW_Kinematic
#------------------------------------------------------------------------------#
#Variables
var direction: Vector2 = Vector2.ZERO
#Bool Variables
var controllable: bool = true
#Exported Variables
@export_range(1, 5, 0.5) var repellent: float
#OnReady Variables
@onready var encounters = $Encounters
@onready var encounter_timer = $Timers/EncounterTimer
@onready var markers = $Markers
#------------------------------------------------------------------------------#
#Ready Function
func _ready() -> void:
	#Snap to Grid
	position = position.snapped(Vector2.ONE * G.TILE_SIZE_OW)
	position -= Vector2.ONE * (float(G.TILE_SIZE_OW) / 2)
#------------------------------------------------------------------------------#
#Player Direction
func move_direction() -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"))
