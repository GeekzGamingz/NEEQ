#Inherits NeeqMovement Code
extends NeeqMovement
class_name NeeqCombat
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export_enum("Explorer", "Combat", "Sneeq", "Magic") var MODE: String
#------------------------------------------------------------------------------#
func handle_mode():
	if (Input.get_action_strength("action_mode1") > 0 &&
		Input.get_action_strength("action_mode2") > 0): MODE = "Magic"
	elif Input.get_action_strength("action_mode1") > 0: MODE = "Combat"
	elif Input.get_action_strength("action_mode2") > 0: MODE = "Sneeq"
	elif (Input.get_action_strength("action_mode1") == 0 &&
		Input.get_action_strength("action_mode2") == 0): MODE = "Explorer"
