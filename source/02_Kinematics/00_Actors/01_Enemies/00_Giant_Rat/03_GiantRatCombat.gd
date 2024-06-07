#Inherits Actor Code
extends EnemyMovement
class_name GiantRatCombat
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D = null
#Bool Variables
var atk_toggle: bool = true
#OnReady Variables
@onready var combat_detectors = $Facing/WorldDetectors/CombatDetectors
@onready var sight_detector: Area2D = combat_detectors.get_node("SightDetector")
@onready var bite_detector: RayCast2D = combat_detectors.get_node("BiteDetector")
@onready var atkbox: CollisionShape2D = combat_detectors.get_node("Atkbox_Light/CollisionShape2D")
@onready var hitbox: CollisionShape2D = combat_detectors.get_node("Hitbox/CollisionShape2D")
@onready var atk_timer: Timer = $Timers/AttackTimer
@onready var damage_timer = $Timers/DamageTimer
#------------------------------------------------------------------------------#
#Neeq Spotted
func _on_sight_detector_body_entered(body):
	if body.name == "Neeq": player = body
#Neeq Lost
func _on_sight_detector_body_exited(body):
	if body.name == "Neeq": player = null
#------------------------------------------------------------------------------#
#Hitbox
func _on_hitbox_area_entered(area):
	match(area.name):
		"Atkbox_Ping": damage(1)
		"Atkbox_Light": damage(5) #Add Strength?
		"Atkbox_Medium": damage(10)
		"Atkbox_Moderate": damage(15)
		"Atkbox_Strong": damage(20)
		"Atkbox_Elite": damage(25)
#------------------------------------------------------------------------------#
#Health Functions
#Heal Switch
func healing(): is_healing = true
#Damage Switch
func hurting(): is_hurting = true
#Kill Switch
func kill(): is_dead = true
