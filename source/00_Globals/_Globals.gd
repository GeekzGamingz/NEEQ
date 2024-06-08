#Inherits Node Code
extends Node
#------------------------------------------------------------------------------#
#Constants
const TILE_SIZE: int = 24
const TILE_SIZE_OW: int = 12
#------------------------------------------------------------------------------#
#Variables
var PLAYER: CharacterBody2D
var WIND: float = 0
#OnReady Variables
@onready var WORLD: Node2D = get_tree().get_root().get_node("WorldRoot")
@onready var ORPHANS: Node2D = WORLD.get_node("Orphans")
@onready var LEVELS: Node2D = WORLD.get_node("Levels")
@onready var UI: MarginContainer = WORLD.get_node("UserInterface/MarginContainer")
@onready var DEBUG: Control = UI.get_node("Menu_Debug")
@onready var ACTIONS: Control = UI.get_node("Overlay_Actions")
@onready var PROGRESS: Control = UI.get_node("ProgressBars")
