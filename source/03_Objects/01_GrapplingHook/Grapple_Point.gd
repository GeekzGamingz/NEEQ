#Inherits StaticBody2D Code
extends StaticBody2D
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D
var tip: CharacterBody2D
#OnReady Variables
@onready var player_holder: RigidBody2D = $PlayerHolder
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	global_position = tip.global_position
	player_holder.global_position = player.global_position
#------------------------------------------------------------------------------#
#Process Function
func _process(_delta):
	var player_state = player.fsm.states
	if ![
		player_state.grapple_hooked,
		player_state.grapple_charge_walk,
		player_state.grapple_charge_run,
		player_state.grapple_charge_air,
		player_state.grapple_fire
		].has(player.fsm.state): queue_free()
	if player.fsm.state == player_state.grapple_hooked:
		player.global_position = player_holder.global_position
