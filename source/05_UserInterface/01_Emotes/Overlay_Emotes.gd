#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
var buttons: Array = []
var wheel_direction: Vector2 = Vector2.ZERO
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	var number = 0
	for button in get_tree().get_nodes_in_group("EmoteButtons"):
		number += 1
		match(number):
			1: button.name = "Exclaim"
			2: button.name = "Interrobang"
			3: button.name = "Love"
			4: button.name = "Button #%s" % [number]
			5: button.name = "Lick"
			6: button.name = "Button #%s" % [number]
			7: button.name = "Button #%s" % [number]
			8: button.name = "Question"
		buttons.append(button)
	print(buttons)
#------------------------------------------------------------------------------#
#Process
func _process(_delta) -> void:
	visible = Input.is_action_pressed("action_emote")
	if visible:
		wheel_direction = Vector2(
			Input.get_axis("wheel_left", "wheel_right"),
			Input.get_axis("wheel_up", "wheel_down"))
		#Verticle
		if wheel_direction.y < 0 && wheel_direction.x == 0: buttons[0].grab_focus()
		elif wheel_direction.y > 0 && wheel_direction.x == 0: buttons[4].grab_focus()
		#Diagnol
		elif wheel_direction.y < 0 && wheel_direction.x > 0.2: buttons[1].grab_focus()
		elif wheel_direction.y > 0 && wheel_direction.x > 0.2: buttons[3].grab_focus()
		elif wheel_direction.y > 0 && wheel_direction.x < 0.2: buttons[5].grab_focus()
		elif wheel_direction.y < 0 && wheel_direction.x < 0.2: buttons[7].grab_focus()
		#Horizontal
		elif wheel_direction.x > 0: buttons[2].grab_focus()
		elif wheel_direction.x < 0: buttons[6].grab_focus()
