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
const UP_SIDE_DOWN: int = -1
const RIGHT_SIDE_UP: int = 1
#------------------------------------------------------------------------------#
#Variables
var facing: Vector2 = Vector2.ONE
var inversion: Vector2 = Vector2.ONE
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
@onready var health: float = max_health: set = set_health
@onready var walk_speed: float = speed * G.TILE_SIZE
@onready var run_speed: float = walk_speed * 2
@onready var max_speed: float = walk_speed
@onready var min_jump_height: float = jump_strength * G.TILE_SIZE
@onready var max_jump_height: float = min_jump_height * 5
@onready var progress_bars: Control = $ProgressBars
@onready var progress_timer: Timer = $Timers/ProgressTimer
#------------------------------------------------------------------------------#
#Gravity
#Applies Gravity
func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x += G.WIND * delta
#Reverses Gravity
func reverse_gravity(delta: float) -> void:
	velocity.y -= gravity * delta
	velocity.x += G.WIND * delta
#------------------------------------------------------------------------------#
#Horizontal Facing
func set_facing(hor_facing: int) -> void:
	if hor_facing == 0:
		hor_facing = FACING_RIGHT
	var hor_face_mod = hor_facing / abs(hor_facing)
	$Facing.apply_scale(Vector2(hor_face_mod * facing.x, 1))
	$CollisionShape2D.position.x *= -1
	facing = Vector2(hor_face_mod, facing.y)
#Vertical Facing
func set_vert(vert_facing: int) -> void:
	if vert_facing == 0:
		vert_facing = RIGHT_SIDE_UP
	var vert_face_mod = vert_facing / abs(vert_facing)
	$Facing.apply_scale(Vector2(1, vert_face_mod * inversion.x))
	$CollisionShape2D.position.y *= -1
	inversion = Vector2(vert_face_mod, inversion.y)
#------------------------------------------------------------------------------#
#Health
#Heal
func heal(amount: float):
	set_health(health + amount)
#Damage
func damage(amount: float):
	set_health(health - amount)
#Set Health
func set_health(value: float):
	progress_bars.visible = true
	progress_timer.start()
	var health_prev = health
	health = clamp(value, 0, max_health)
	if health > health_prev:
		healing()
		emit_signal("health_heal", health)
		if name == "Neeq":
			G.PROGRESS.health_heal(health)
	if health < health_prev:
		hurting()
		emit_signal("health_damage", health)
		if health == 0:
			kill()
			G.time_alter(0.1, 0.1)
		if name == "Neeq":
			G.PROGRESS.health_damage(health)
#Heal Switch
func healing(): pass
#Damage Switch
func hurting(): pass
#Kill Switch
func kill(): pass
#Visibility Timer
func _on_progress_timer_timeout() -> void: progress_bars.visible = false
