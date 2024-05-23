#Inherits Area2D Code
extends Area2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export_category("Custom Values")
@export var top: float = 0
@export var bottom: float = 800
@export var left: float = 0
@export var right: float = 1280
@export var camera: Camera2D = null
#Exported Enumerations
@export_enum("Horizontal", "Verticle", "Forward", "Backward", "Custom") var panning: String = "Horizontal"
#OnReady Variables
@onready var view_width = get_viewport_rect().size.x
@onready var view_height = get_viewport_rect().size.y
#------------------------------------------------------------------------------#
func _on_body_entered(body):
	if body.name == "Neeq":
		match(panning):
			"Horizontal":
				top = 0
				bottom = global_position.y + G.TILE_SIZE * 2
				left = 0
				right = view_width
			"Verticle":
				top = 0
				bottom = view_height
				left = global_position.x - view_width / camera.zoom.x / 2
				right = global_position.x + view_width / camera.zoom.x / 2
			"Forward":
				top = 0
				bottom = global_position.y + G.TILE_SIZE * 2
				left = global_position.x - view_width / camera.zoom.x / 2
				right = view_width
			"Backward":
				top = 0
				bottom = global_position.y + G.TILE_SIZE * 2
				left = 0
				right = global_position.x + view_width / camera.zoom.x / 2
			"Custom": pass
		camera.set_panning(top, bottom, left, right)
		camera.panning = panning
	
