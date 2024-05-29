#Inherits TileMap Code
extends TileMap
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export var player: CharacterBody2D
#OnReady Variables
@onready var tile_data: TileData = get_cell_tile_data(2, Vector2i(player.position))

