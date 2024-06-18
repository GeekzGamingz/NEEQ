#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D
#------------------------------------------------------------------------------#
func _process(_delta: float) -> void:
	if player == null:
		player = G.PLAYER
		#position = G.PLAYER.position
