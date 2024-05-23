#Inherits Actor Code
extends EnemyMovement
class_name GiantRatMovement
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
@onready var atk_timer: Timer = $Timers/AttackTimer
#------------------------------------------------------------------------------#
#Neeq Spotted
func _on_sight_detector_body_entered(body):
	if body.name == "Neeq": player = body
#Neeq Lost
func _on_sight_detector_body_exited(body):
	if body.name == "Neeq": player = null
#------------------------------------------------------------------------------#
func atkbox_toggle() -> void:
	atkbox.set_deferred("disabled", !atk_toggle)
	atk_toggle = !atk_toggle
