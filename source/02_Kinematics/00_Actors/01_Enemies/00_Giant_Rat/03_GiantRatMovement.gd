#Inherits Actor Code
extends EnemyMovement
class_name GiantRatMovement
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D = null
#Bool Variables
var atk_toggle: bool = true
#OnReady Variables
@onready var sight_detector: Area2D = $Facing/WorldDetectors/SightDetector
@onready var bite_detector: RayCast2D = $Facing/WorldDetectors/BiteDetector
@onready var atkbox: CollisionShape2D = $Facing/WorldDetectors/Atkbox_Light/CollisionShape2D
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
