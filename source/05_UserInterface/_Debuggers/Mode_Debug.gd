#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export var player: CharacterBody2D
@export var camera: Camera2D
#OnReady Variables
@onready var position_output = $VBoxContainer/GridContainer/PositionOutput
@onready var state_output = $VBoxContainer/GridContainer/StateOutput
@onready var camera_output = $VBoxContainer/GridContainer/CameraOutput
@onready var camera_target_output = $VBoxContainer/GridContainer/CameraTargetOutput
@onready var player_mode_output = $VBoxContainer/GridContainer/PlayerModeOutput
#------------------------------------------------------------------------------#
func _ready():
	visible = false
#------------------------------------------------------------------------------#
func _process(_delta: float):
	#Player Outputs
	var snapped_position = player.global_position.snapped(Vector2.ONE * 0.01)
	position_output.text = str(snapped_position) #Position
	state_output.text = str(player.fsm.state_label.text) #State
	player_mode_output.text = str(player.MODE) #Mode
	#Camera Outputs
	camera_output.text = str(camera.panning)
	camera_target_output.text = str(camera.focus.name)
	#Toggle Visibility
	if Input.is_action_just_released("F3"):
		visible = !visible
