#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Constants
const ACTOR_OW: PackedScene = preload("res://source/02_Kinematics/01_OWActors/Actor_OW.tscn")
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p: Node2D = get_parent()
@onready var terrain_detector: Area2D = $TerrainDetector
@onready var north_detector: Area2D = $"../Markers/NorthMarker/TerrainDetector"
@onready var south_detector: Area2D = $"../Markers/SouthMarker/TerrainDetector"
@onready var east_detector: Area2D = $"../Markers/EastMarker/TerrainDetector"
@onready var west_detector: Area2D = $"../Markers/WestMarker/TerrainDetector"
#------------------------------------------------------------------------------#
func random_encounter() -> void:
	G.DEBUG.biome = terrain_detector.biome
	for marker in p.markers.get_children():
		if (p.get_parent().get_children().size() < 4 &&
			terrain_detector.biome != "Path" &&
			marker.get_node("TerrainDetector").biome != "Water"):
			p.encounter_timer.wait_time = max(p.speed, p.speed * p.repellent)
			p.encounter_timer.start()
			var encounter_chance = p.rng.randi_range(0, 100)
			print_rich("[u][b]Encounter Value[/b][/u] [d100]: ", encounter_chance)
			if range(0, 9).has(encounter_chance):
				var enc_scene = ACTOR_OW.instantiate()
				enc_scene.global_position = marker.global_position
				enc_scene.LEVEL = "Mystery"
				p.get_parent().add_child(enc_scene)
				print_rich("- [b]Encounter Name[/b]: [wave][rainbow]Mystery[/rainbow][/wave]")
				print_rich("- [b]Encounter Chance[/b]: 10%")
				print_rich("- [b]Encounter Threat[/b]: Unknown")
			elif range(75, 89).has(encounter_chance):
				var enc_scene = ACTOR_OW.instantiate()
				enc_scene.global_position = marker.global_position
				enc_scene.LEVEL = "Minor"
				p.get_parent().add_child(enc_scene)
				print_rich("- [b]Encounter Name[/b]: Minor")
				print_rich("- [b]Encounter Chance[/b]: 15%")
				print_rich("- [b]Encounter Threat[/b]: Negliable")
			elif range(90, 94).has(encounter_chance):
				var enc_scene = ACTOR_OW.instantiate()
				enc_scene.global_position = marker.global_position
				enc_scene.LEVEL = "Moderate"
				p.get_parent().add_child(enc_scene)
				print_rich("- [b]Encounter Name[/b]: Moderate")
				print_rich("- [b]Encounter Chance[/b]: 5%")
				print_rich("- [b]Encounter Threat[/b]: Fair")
			elif range(95, 99).has(encounter_chance):
				var enc_scene = ACTOR_OW.instantiate()
				enc_scene.global_position = marker.global_position
				enc_scene.LEVEL = "Major"
				p.get_parent().add_child(enc_scene)
				print_rich("- [b]Encounter Name[/b]: Major")
				print_rich("- [b]Encounter Chance[/b]: 5%")
				print_rich("- [b]Encounter Threat[/b]: Potent")
			elif [100].has(encounter_chance):
				print_rich("- [b]Encounter Name[/b]: Dragon")
				print_rich("- [b]Encounter Chance[/b]: 1%")
				print_rich("- [b]Encounter Threat[/b]: [shake][color=red]DRAGON[/color][/shake]")
			else:
				print_rich("- [b]Encounter Name[/b]: [s]Null[/s]")
				print_rich("- [b]Encounter Chance[/b]: 75%")
				print_rich("- [b]Encounter Threat[/b]: Zero")
			print_rich("- [b]Encounter Biome[/b]: ", terrain_detector.biome)
			print("#-------------------------#")
		
