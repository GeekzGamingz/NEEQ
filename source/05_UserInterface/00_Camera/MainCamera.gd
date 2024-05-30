#Inherits Camera2D Code
extends Camera2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export var focus: CharacterBody2D = null
@export_enum("Horizontal", "Verticle", "Forward", "Backward", "Custom") var panning: String = "Custom"
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	G.DEBUG.camera = self
#------------------------------------------------------------------------------#
func _process(_delta) -> void:
	global_position = focus.global_position
#------------------------------------------------------------------------------#
#Verticle Panning
func set_panning(t: int, b: int, l: int, r: int) -> void:
	limit_top = t
	limit_bottom = b
	limit_left = l
	limit_right = r
