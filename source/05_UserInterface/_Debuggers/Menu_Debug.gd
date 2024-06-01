#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D
var camera: Camera2D
var biome: String
#OnReady Variables
@onready var position_output = $VBoxContainer/GridContainer/PositionOutput
@onready var state_output = $VBoxContainer/GridContainer/StateOutput
@onready var camera_output = $VBoxContainer/GridContainer/CameraOutput
@onready var camera_target_output = $VBoxContainer/GridContainer/CameraTargetOutput
@onready var player_mode_output = $VBoxContainer/GridContainer/PlayerModeOutput
@onready var biome_output = $VBoxContainer/GridContainer/BiomeOutput
@onready var lives_outputs = $VBoxContainer/GridContainer/LivesOutputs
#------------------------------------------------------------------------------#
func _ready():
	visible = false
#------------------------------------------------------------------------------#
func _process(_delta: float):
	if player == null: player = G.PLAYER
	#Player Outputs
	else:
		var snapped_position = player.global_position.snapped(Vector2.ONE * 0.01)
		position_output.text = str(snapped_position) #Position
		state_output.text = str(player.fsm.state_label.text) #State
		if player.name == "Neeq": player_mode_output.text = str(player.MODE)
		elif player.name == "Neeq_Overworld": player_mode_output.text = ("Overworld")
	#Camera Outputs
	if camera != null:
		camera_output.text = str(camera.panning)
		camera_target_output.text = str(camera.focus.name)
	#Biome Output
	if biome != "":
		biome_output.text = biome
	else: biome_output.text = "Path"
	#Lives Output
	lives_outputs.text = str(S.life_count)
	#Toggle Visibility
	if Input.is_action_just_released("F3"):
		visible = !visible
