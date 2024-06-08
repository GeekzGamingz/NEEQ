#Inherits OW_Kinematic Coce
extends OW_Kinematic
#------------------------------------------------------------------------------#
#Constants
const OW_ENCOUNTER_MINOR: Texture2D = preload("res://assets/02_Actors/_Overworld/overworld_minor_enemy.png")
const OW_ENCOUNTER_MODERATE: Texture2D = preload("res://assets/02_Actors/_Overworld/overworld_moderate_enemy.png")
const OW_ENCOUNTER_MAJOR: Texture2D = preload("res://assets/02_Actors/_Overworld/overworld_major_enemy.png")
const OW_ENCOUNTER_MYSTERY: Texture2D = preload("res://assets/02_Actors/_Overworld/overworld_mystery.png")
#------------------------------------------------------------------------------#
#Variables
var direction: Vector2 = Vector2.ZERO
#Bool Variables
var controllable: bool = true
#Exported Variables
@export_enum("Minor", "Moderate", "Major", "Mystery") var LEVEL: String
#OnReady Variables
@onready var sprite: Sprite2D = $Sprite_OW
@onready var despawn_timer: Timer = $Timers/DespawnTimer
#------------------------------------------------------------------------------#
#Ready Function
func _ready() -> void:
	#Snap to Grid
	position = position.snapped(Vector2.ONE * G.TILE_SIZE_OW)
	position -= Vector2.ONE * (float(G.TILE_SIZE_OW) / 2)
	match(LEVEL):
		"Minor": sprite.texture = OW_ENCOUNTER_MINOR
		"Moderate": sprite.texture = OW_ENCOUNTER_MODERATE
		"Major": sprite.texture = OW_ENCOUNTER_MAJOR
		"Mystery":
			delay = 0.4
			despawn_timer.wait_time = 3
			sprite.texture = OW_ENCOUNTER_MYSTERY
	despawn_timer.start()
#------------------------------------------------------------------------------#
#Player Direction
func move_direction() -> void:
	randomize()
	var r_verticle = rng.randi_range(-1, 1)
	var r_horizontal = rng.randi_range(-1, 1)
	direction = Vector2(r_verticle, r_horizontal)
#Despawn
func _on_despawn_timer_timeout() -> void:
	queue_free()
