#Inherits Node Code
extends Node
#------------------------------------------------------------------------------#
#Signals
signal life_update
#Variables
var life_count: int = 3: set = set_life_count
#------------------------------------------------------------------------------#
#Global Functions
func set_life_count(value: int) -> void:
	life_count = life_count + value
	emit_signal("life_update")
