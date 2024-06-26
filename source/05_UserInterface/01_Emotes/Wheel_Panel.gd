#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var button = $TextureButton
#------------------------------------------------------------------------------#
#Mouse Focus
func _on_texture_button_mouse_entered():
	button.grab_focus()
#When Focused
func _on_texture_button_focus_entered():
	pass
