#Inherits OW_Kinematic Coce
extends OW_Kinematic
#------------------------------------------------------------------------------#
#Constants
const OW_ENCOUNTER_MINOR = preload("res://assets/02_Actors/_Overworld/overworld_minor_enemy.png")
const OW_ENCOUNTER_MODERATE= preload("res://assets/02_Actors/_Overworld/overworld_moderate_enemy.png")
const OW_ENCOUNTER_MASTER = preload("res://assets/02_Actors/_Overworld/overworld_master_enemy.png")
const OW_ENCOUNTER_MYSTERY = preload("res://assets/02_Actors/_Overworld/overworld_mystery.png")
#------------------------------------------------------------------------------#
#Variables
var direction: Vector2 = Vector2.ZERO
#Bool Variables
var controllable: bool = true
#Exported Variables
@export_enum("Minor", "Moderate", "Master", "Mystery") var LEVEL: String
#OnReady Variables
@onready var sprite = $Sprite_OW
@onready var despawn_timer = $Timers/DespawnTimer
#------------------------------------------------------------------------------#
#Ready Function
func _ready() -> void:
	#Snap to Grid
	position = position.snapped(Vector2.ONE * G.TILE_SIZE_OW)
	position -= Vector2.ONE * (float(G.TILE_SIZE_OW) / 2)
	match(LEVEL):
		"Minor": sprite.texture = OW_ENCOUNTER_MINOR
		"Moderate": sprite.texture = OW_ENCOUNTER_MODERATE
		"Master": sprite.texture = OW_ENCOUNTER_MASTER
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
func _on_despawn_timer_timeout():
	queue_free()
