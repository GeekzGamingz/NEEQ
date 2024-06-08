#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Variables
var flying: bool = false
var hooked: bool = false
var direction: Vector2 = Vector2.ZERO
var tip_position: Vector2 = Vector2.ZERO
#Exported Variables
@export var speed: float = G.TILE_SIZE / 2.0
#OnReady Variables
@onready var links: Sprite2D = $Links
@onready var tip: CharacterBody2D = $Tip
@onready var grapple_guide: Sprite2D = $GrappleGuideSprite
@onready var grapple_destination: Marker2D = $GrappleGuideSprite/GrappleDestination
#------------------------------------------------------------------------------#
#Process
func _process(_delta: float) -> void:
	tip.visible = flying || hooked
	links.visible = tip.visible
	if !tip.visible: return
	var tip_loc = to_local(tip_position)
	links.rotation = position.angle_to_point(tip_loc) - deg_to_rad(-90)
	tip.rotation = position.angle_to_point(tip_loc) - deg_to_rad(-90)
	links.position = tip_loc
	links.region_rect.size.y = tip_loc.length()
#------------------------------------------------------------------------------#
#Physics Process
func _physics_process(_delta: float) -> void:
	tip.global_position = tip_position
	if flying: if tip.move_and_collide(direction * speed):
		hooked = true
		flying = false
	tip_position = tip.global_position
#------------------------------------------------------------------------------#
#Grapple Functions
#Shoot
func shoot(dir: Vector2) -> void:
	direction = dir.normalized()
	flying = true
	tip_position = global_position
#Release
func release() -> void:
	flying = false
	hooked = false
