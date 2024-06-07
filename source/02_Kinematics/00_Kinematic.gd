#Inherits CharacterBody2D Code
extends CharacterBody2D
class_name Kinematic
#------------------------------------------------------------------------------#
#Signals
signal health_heal(health)
signal health_damage(damage)
#------------------------------------------------------------------------------#
#Constants
const FACING_LEFT: int = -1
const FACING_RIGHT: int = 1
#------------------------------------------------------------------------------#
#Variables
var facing: Vector2 = Vector2(FACING_RIGHT, 1)
#Movement Variables
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var min_jump_velocity: float = 0.0
var max_jump_velocity: float = 0.0
#Bool Variables
var is_healing: bool = false
var is_hurting: bool = false
var is_dead: bool = false
#Exported Variables
@export var max_health: float = 100
@export var speed: float = 3.5
@export var jump_strength: float = 0.5
@export var jump_duration: float = 0.5
#OnReady Variables
@onready var p = get_parent()
@onready var health = max_health: set = set_health
@onready var walk_speed: float = speed * G.TILE_SIZE
@onready var run_speed: float = walk_speed * 2
@onready var max_speed: float = walk_speed
@onready var min_jump_height: float = jump_strength * G.TILE_SIZE
@onready var max_jump_height: float = min_jump_height * 5
#------------------------------------------------------------------------------#
#Applies Gravity
func apply_gravity(delta) -> void:
	velocity.y += gravity * delta
	velocity.x += G.WIND * delta
#------------------------------------------------------------------------------#
#Set Facing
func set_facing(hor_facing) -> void:
	if hor_facing == 0:
		hor_facing = FACING_RIGHT
	var hor_face_mod = hor_facing / abs(hor_facing)
	$Facing.apply_scale(Vector2(hor_face_mod * facing.x, 1))
	facing = Vector2(hor_face_mod, facing.y)
#------------------------------------------------------------------------------#
#Health
#Heal
func heal(amount):
	set_health(health + amount)
#Damage
func damage(amount):
	set_health(health - amount)
#Set Health
func set_health(value):
	var health_prev = health
	health = clamp(value, 0, max_health)
	if health > health_prev:
		healing()
		if health == 100: pass
		emit_signal("health_heal", health)
		if name == "Neeq":
			G.UI.PROGRESS.health_heal(health)
	if health < health_prev:
		hurting()
		emit_signal("health_damage", health)
		if health == 0:
			kill()
			Engine.time_scale = 0.1
			await get_tree().create_timer(0.1).timeout
			Engine.time_scale = 1
		if name == "Neeq":
			G.PROGRESS.health_damage(health)
#Heal Switch
func healing(): pass
#Damage Switch
func hurting(): pass
#Kill Switch
func kill(): pass
