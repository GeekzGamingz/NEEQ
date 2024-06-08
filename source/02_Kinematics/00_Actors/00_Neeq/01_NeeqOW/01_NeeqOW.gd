#Inherits OW_Kinematic Coce
extends OW_Kinematic
#------------------------------------------------------------------------------#
#Variables
var direction: Vector2 = Vector2.ZERO
var MODE: String = "Overworld"
#Bool Variables
var controllable: bool = true
#Exported Variables
@export_range(1, 5, 0.5) var repellent: float
#OnReady Variables
@onready var encounters: Node2D = $Encounters
@onready var encounter_timer: Timer = $Timers/EncounterTimer
@onready var markers: Node2D = $Markers
@onready var fsm: Node2D = get_child(0)
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
