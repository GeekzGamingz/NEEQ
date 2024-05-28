#Inherits Area2D Code
extends Area2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export_enum("Overworld", "Debug") var LEVEL: String
#OnReady Variables
@onready var p = get_parent()
#------------------------------------------------------------------------------#
func _on_body_entered(body):
	if body.name == "Neeq_Overworld" || body.name == "Neeq":
		var level_scene
		match(LEVEL):
			"Overworld": level_scene = load("res://source/01_World/00_Overworld/00_OWDebug/OW_Debug.tscn")
			"Debug": level_scene = load("res://source/01_World/01_Levels/00_Debug/Level_Debug.tscn")
		level_scene = level_scene.instantiate()
		G.LEVELS.get_child(0).call_deferred("free")
		G.LEVELS.call_deferred("add_child", level_scene)
