#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Constants
const CONTROLLERS = [
	preload("res://assets/04_UserInterface/02_Controls/XBOX360.png"),
	preload("res://assets/04_UserInterface/02_Controls/XBOXone.png"),
	preload("res://assets/04_UserInterface/02_Controls/PS2.png"),
	preload("res://assets/04_UserInterface/02_Controls/PS4.png"),
	preload("res://assets/04_UserInterface/02_Controls/Switch.png"),
	preload("res://assets/04_UserInterface/02_Controls/Mouse_Keyboard.png")
	]
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D
var button_id: int = 0
#Exported Variables
@export_enum(
	"XBox360",
	"XboxONE",
	"PS2",
	"PS4",
	"Switch",
	"Mouse & Keyboard"
	) var CONTROLLER: String = "Xbox360"
#OnReady Variables
#Icon Sprites
@onready var icon_mode = $MarginContainer/GridContainer/MODE_Icon/Icon_MODE
@onready var icon_quick = $MarginContainer/GridContainer/Quick_Icon/Icon_Quick
@onready var icon_interact = $MarginContainer/GridContainer/Interact_Icon/Icon_Interact
@onready var icon_cancel = $MarginContainer/GridContainer/Cancel_Icon/Icon_Cancel
@onready var icon_travel = $MarginContainer/GridContainer/Travel_Icon/Icon_Travel
#Button Sprites
@onready var buttons = [
	$MarginContainer/GridContainer/Mode1_Control/Button_Mode1,
	$MarginContainer/GridContainer/Mode2_Control/Button_Mode2,
	$MarginContainer/GridContainer/Emote_Control/Button_Emote,
	$MarginContainer/GridContainer/Interact_Control/Button_Interact,
	$MarginContainer/GridContainer/Grapple_Control/Button_Grapple,
	$MarginContainer/GridContainer/Quick_Control/Button_Quick,
	$MarginContainer/GridContainer/Cancel_Control/Button_Cancel,
	$MarginContainer/GridContainer/Travel_Control/Button_Travel
	]
#Animation Players
@onready var icon_player = $AnimationPlayers/IconPlayer
#Button Players
@onready var quick_player = $AnimationPlayers/ButtonPlayers/QuickPlayer
@onready var interact_player = $AnimationPlayers/ButtonPlayers/InteractPlayer
@onready var cancel_player = $AnimationPlayers/ButtonPlayers/CancelPlayer
@onready var travel_player = $AnimationPlayers/ButtonPlayers/TravelPlayer
@onready var emote_player = $AnimationPlayers/ButtonPlayers/EmotePlayer
@onready var grapple_player = $AnimationPlayers/ButtonPlayers/GrapplePlayer
@onready var mode1_player = $AnimationPlayers/ButtonPlayers/Mode1Player
@onready var mode2_player = $AnimationPlayers/ButtonPlayers/Mode2Player
#------------------------------------------------------------------------------#
#Process Method
func _process(_delta) -> void:
	if player == null:
		player = G.PLAYER
		if player.name == "Neeq_Overworld": icon_player.play("Overworld")
#------------------------------------------------------------------------------#
#Unhandled Input
func _input(event) -> void:
	#Icon Swaps
	if event.is_action_pressed("action_quick"): quick_player.play("quick_pressed")
	elif event.is_action_released("action_quick"): quick_player.play("quick")
	if event.is_action_pressed("action_interact"): interact_player.play("interact_pressed")
	elif event.is_action_released("action_interact"): interact_player.play("interact")
	if event.is_action_pressed("action_cancel"): cancel_player.play("cancel_pressed")
	elif event.is_action_released("action_cancel"): cancel_player.play("cancel")
	if event.is_action_pressed("action_travel"): travel_player.play("travel_pressed")
	elif event.is_action_released("action_travel"): travel_player.play("travel")
	if event.is_action_pressed("action_emote"): emote_player.play("emote_pressed")
	elif event.is_action_released("action_emote"): emote_player.play("emote")
	if event.is_action_pressed("action_grapple"): grapple_player.play("grapple_pressed")
	elif event.is_action_released("action_grapple"): grapple_player.play("grapple")
	if event.is_action_pressed("action_mode1"): mode1_player.play("mode1_pressed")
	elif event.is_action_released("action_mode1"): mode1_player.play("mode1")
	if event.is_action_pressed("action_mode2"): mode2_player.play("mode2_pressed")
	elif event.is_action_released("action_mode2"): mode2_player.play("mode2")
	#Button Swaps
	if event.is_action_pressed("F2"):
		for button in buttons: button.texture = CONTROLLERS[button_id]
		match(button_id):
			0: CONTROLLER = "XBox360"
			1: CONTROLLER = "XBoxONE"
			2: CONTROLLER = "PS2"
			3: CONTROLLER = "PS4"
			4: CONTROLLER = "Switch"
			5: CONTROLLER = "Mouse & Keyboard"
		button_id += 1
		if button_id == CONTROLLERS.size(): button_id = 0
#------------------------------------------------------------------------------#
