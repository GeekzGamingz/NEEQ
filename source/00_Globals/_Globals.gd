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
@onready var WORLD = get_tree().get_root().get_node("WorldRoot")
@onready var ORPHANS = WORLD.get_node("Orphans")
@onready var LEVELS = WORLD.get_node("Levels")
@onready var UI = WORLD.get_node("UserInterface/MarginContainer")
@onready var DEBUG = UI.get_node("Menu_Debug")
@onready var ACTIONS = UI.get_node("Overlay_Actions")
