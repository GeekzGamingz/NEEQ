#Inherits Marker2D Code
extends Marker2D
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p = get_parent().get_parent()
#------------------------------------------------------------------------------#
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("action_emote"): pass #Toggle Wheel Visibility
	if event.is_action_released("action_emote"):
		if Input.get_action_strength("wheel_up") > 0: p.play_emote("Exclaim")
		elif Input.get_action_strength("wheel_down") > 0: p.play_emote("Question")
