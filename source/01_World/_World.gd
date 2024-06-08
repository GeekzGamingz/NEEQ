#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Unhandled Input
func _unhandled_input(event: InputEvent) -> void:
	#Killswitch
	if event.is_action_pressed("ESC"): get_tree().quit()
