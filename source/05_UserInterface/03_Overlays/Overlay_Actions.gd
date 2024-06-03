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
#Button Players
@onready var quick_player = $AnimationPlayers/ButtonPlayers/QuickPlayer
@onready var interact_player = $AnimationPlayers/ButtonPlayers/InteractPlayer
@onready var cancel_player = $AnimationPlayers/ButtonPlayers/CancelPlayer
@onready var travel_player = $AnimationPlayers/ButtonPlayers/TravelPlayer
#------------------------------------------------------------------------------#
#Process Method
func _process(_delta) -> void:
	if player == null:
		player = G.PLAYER
		if player.name == "Neeq_Overworld": icon_player.play("Overworld")
#------------------------------------------------------------------------------#
#Unhandled Input
func _unhandled_input(event) -> void:
	#Key Swaps
	if event.is_action_pressed("action_quick"): quick_player.play("quick_pressed")
	elif event.is_action_released("action_quick"): quick_player.play("quick")
	if event.is_action_pressed("action_interact"): interact_player.play("interact_pressed")
	elif event.is_action_released("action_interact"): interact_player.play("interact")
	if event.is_action_pressed("action_cancel"): cancel_player.play("cancel_pressed")
	elif event.is_action_released("action_cancel"): cancel_player.play("cancel")
	if event.is_action_pressed("action_travel"): travel_player.play("travel_pressed")
	elif event.is_action_released("action_travel"): travel_player.play("travel")
#------------------------------------------------------------------------------#
