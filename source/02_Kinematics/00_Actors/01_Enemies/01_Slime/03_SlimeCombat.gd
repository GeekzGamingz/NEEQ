#Inherits EnemyMovement Code
extends EnemyMovement
class_name SlimeCombat
#------------------------------------------------------------------------------#
#Variables
#Bool Variables
var is_pooled: bool = false
#Exported Variables
@export_enum( "Grounded", "Lurking", "Spawning") var MODE = "Grounded"
#OnReady Variables
@onready var combat_detectors = $Facing/WorldDetectors/CombatDetectors
@onready var atkbox = combat_detectors.get_node("Atkbox_Ping/CollisionShape2D")
#------------------------------------------------------------------------------#
func _on_animation_tree_animation_finished(anim_name):
	match(anim_name):
		"drip_pool": is_pooled = true
#------------------------------------------------------------------------------#
#Hitbox
func _on_hitbox_area_entered(area):
	match(area.name):
		"Atkbox_Ping": damage(100)
		"Atkbox_Light": damage(100) #Add Strength?
		"Atkbox_Medium": damage(100)
		"Atkbox_Moderate": damage(100)
		"Atkbox_Strong": damage(100)
		"Atkbox_Elite": damage(100)
#Down Thrust
func _on_hitbox_body_entered(body):
	match(body.name):
		"Neeq": if body.fsm.state == body.fsm.states.combat_downthrust:
			body.velocity.y = body.max_jump_velocity
#------------------------------------------------------------------------------#
#Health Functions
#Heal Switch
func healing(): is_healing = true
#Damage Switch
func hurting(): is_hurting = true
#Kill Switch
func kill():
	atkbox.set_deferred("disabled", true)
	is_dead = true
