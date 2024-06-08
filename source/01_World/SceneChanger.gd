#Inherits Area2D Code
extends Area2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export var custom_scene: PackedScene
@export_enum("Overworld", "Debug", "Random", "Custom") var LEVEL: String
#OnReady Variables
@onready var p: Node2D = get_parent()
#------------------------------------------------------------------------------#
func _on_body_entered(body):
	if body.name == "Neeq_Overworld" || body.name == "Neeq":
		var level_scene
		match(LEVEL):
			"Overworld": level_scene = load("res://source/01_World/00_Overworld/Overworld.tscn")
			"Debug": level_scene = load("res://source/01_World/01_Levels/00_Debug/Level_Debug.tscn")
			"Random": level_scene = load("res://source/01_World/01_Levels/01_Random/Level_Random.tscn")
			"Custom": if custom_scene != null: level_scene = custom_scene
		level_scene = level_scene.instantiate()
		if LEVEL == "Random": level_scene.LEVEL = p.LEVEL
		G.LEVELS.get_child(0).call_deferred("free")
		G.LEVELS.call_deferred("add_child", level_scene)
