#Inherits Node Code
extends Node
#------------------------------------------------------------------------------#
#Constants
const TILE_SIZE: int = 24
const TILE_SIZE_OW: int = 12
#------------------------------------------------------------------------------#
#Variables
var WIND: float = 0
#OnReady Variables
@onready var WORLD = get_tree().get_root().get_node("WorldRoot")
@onready var ORPHANS = WORLD.get_node("OrphanNodes")
