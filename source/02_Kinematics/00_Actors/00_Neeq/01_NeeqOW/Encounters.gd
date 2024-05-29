#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Constants
const ACTOR_OW = preload("res://source/02_Kinematics/01_OWActors/Actor_OW.tscn")
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var p = get_parent()
#------------------------------------------------------------------------------#
func random_encounter():
	for marker in p.markers.get_children():
		if p.get_parent().get_children().size() < 4:
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
				enc_scene.LEVEL = "Master"
				p.get_parent().add_child(enc_scene)
				print_rich("- [b]Encounter Name[/b]: Master")
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
			print("#-------------------------#")
		
