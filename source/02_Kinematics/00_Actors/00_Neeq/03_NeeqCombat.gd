#Inherits NeeqMovement Code
extends NeeqMovement
class_name NeeqCombat
#------------------------------------------------------------------------------#
#Constants
const FX_IMPACT: PackedScene = preload("res://source/03_Objects/01_Particles/02_ImpactParticles/FX_Impact.tscn")
const ATTACK_JUMP: AudioStreamWAV = preload("res://assets/05_SFX/00_Neeq/Attack_Jump.wav")
#------------------------------------------------------------------------------#
#Variables
var last_action: String = ""
#Exported Variables
@export var charge_strength: float = 0.01
@export var combat_jump_multiplier: float = 1.0
@export_enum("Explorer", "Combat", "Sneeq", "Friends") var MODE: String
#OnReady Variables
@onready var atkbox_light: Area2D = $Facing/WorldDetectors/CombatDetectors/Atkbox_Light
@onready var atk_light_col: CollisionShape2D = atkbox_light.get_node("CollisionShape2D")
@onready var atkbox_medium: Area2D = $Facing/WorldDetectors/CombatDetectors/Atkbox_Medium
@onready var atk_medium_col: CollisionShape2D = atkbox_medium.get_node("CollisionShape2D")
@onready var quick_attack_timer: Timer = $Timers/QuickAttackTimer
@onready var strong_attack_timer: Timer = $Timers/StrongAttackTimer
@onready var combo_timer: Timer = $Timers/ComboTimer
@onready var damage_timer: Timer = $Timers/DamageTimer
#------------------------------------------------------------------------------#
#Combat Input
#Handle Mode,
func handle_mode() -> void:
	if (Input.get_action_strength("action_mode1") > 0 &&
		Input.get_action_strength("action_mode2") > 0):
		MODE = "Friends"
		G.ACTIONS.icon_player.play("Friends")
	elif Input.get_action_strength("action_mode1") > 0:
		MODE = "Combat"
		G.ACTIONS.icon_player.play("Combat")
	elif Input.get_action_strength("action_mode2") > 0:
		MODE = "Sneeq"
		G.ACTIONS.icon_player.play("Sneeq")
	elif (Input.get_action_strength("action_mode1") == 0 &&
		Input.get_action_strength("action_mode2") == 0):
		MODE = "Explorer"
		G.ACTIONS.icon_player.play("Explorer")
#Update Last Action Pressed
func update_last_action() -> void:
	if combo_timer.is_stopped():
		if Input.is_action_just_pressed("action_quick"):
			last_action = "Quick"
			combo_timer.start()
		elif Input.is_action_just_pressed("action_interact"):
			last_action = "Interact"
			combo_timer.start()
		elif Input.is_action_just_pressed("action_travel"):
			last_action = "Travel"
			combo_timer.start()
		elif Input.is_action_just_pressed("action_cancel"):
			last_action = "Cancel"
			combo_timer.start()
		else: last_action = ""
#------------------------------------------------------------------------------#
#Hitbox
func _on_hitbox_area_entered(area: Area2D) -> void:
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
#------------------------------------------------------------------------------#
#Light Attack
func _on_atkbox_light_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		var area_radius = area.get_child(0).shape.radius
		var impact_particle = FX_IMPACT.instantiate()
		var col_contacts = (atk_light_col.shape.collide_and_get_contacts(
			global_transform, atk_light_col.shape, area.global_transform))
		if !col_contacts.is_empty():
			if facing.x == FACING_RIGHT: impact_particle.global_position = (
				col_contacts[0] + Vector2(area_radius, -area_radius))
			else: impact_particle.global_position = (
				col_contacts[0] + Vector2(-area_radius, -area_radius))
		else:
			if facing.x == FACING_RIGHT: impact_particle.global_position = (
			((atkbox_light.global_position + area.global_position) / 2) +
			Vector2(area_radius, -area_radius))
			else: impact_particle.global_position = (
			((atkbox_light.global_position + area.global_position) / 2) +
			Vector2(-area_radius, -area_radius))
		impact_particle.scale = Vector2(0.5, 0.5)
		G.ORPHANS.add_child(impact_particle)
#Medium Attack
func _on_atkbox_medium_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		var area_radius = area.get_child(0).shape.radius
		var impact_particle = FX_IMPACT.instantiate()
		var col_contacts = (atk_light_col.shape.collide_and_get_contacts(
			global_transform, atk_light_col.shape, area.global_transform))
		if !col_contacts.is_empty():
			if facing.x == FACING_RIGHT: impact_particle.global_position = (
				col_contacts[1] + Vector2(area_radius, -area_radius))
			else: impact_particle.global_position = (
				col_contacts[1] + Vector2(-area_radius, -area_radius))
		else:
			if facing.x == FACING_RIGHT: impact_particle.global_position = (
			((atkbox_light.global_position + area.global_position) / 2) +
			Vector2(area_radius, -area_radius))
			else: impact_particle.global_position = (
			((atkbox_light.global_position + area.global_position) / 2) +
			Vector2(-area_radius, -area_radius))
		impact_particle.scale = Vector2(0.75, 0.75)
		G.ORPHANS.add_child(impact_particle)
#------------------------------------------------------------------------------#
