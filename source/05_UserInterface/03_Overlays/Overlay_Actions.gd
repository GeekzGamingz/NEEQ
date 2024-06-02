#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D
#OnReady Variables
@onready var icon_mode = $MarginContainer/GridContainer/MODE_Icon/Icon_MODE
@onready var icon_quick = $MarginContainer/GridContainer/Quick_Icon/Icon_Quick
@onready var icon_travel = $MarginContainer/GridContainer/Travel_Icon/Icon_Travel
@onready var icon_interact = $MarginContainer/GridContainer/Interact_Icon/Icon_Interact
@onready var icon_cancel = $MarginContainer/GridContainer/Cancel_Icon/Icon_Cancel
#Animation Players
@onready var icon_player = $AnimationPlayers/IconPlayer
@onready var button_player = $AnimationPlayers/ButtonPlayer
#------------------------------------------------------------------------------#
func _process(_delta):
	if player == null:
		player = G.PLAYER
		if player.name == "Neeq_Overworld": icon_player.play("Overworld")
