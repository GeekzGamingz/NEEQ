#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Constants
const GRAPPLE_POINT = preload("res://source/03_Objects/01_GrapplingHook/Grapple_Point.tscn")
#------------------------------------------------------------------------------#
#Variables
var flying: bool = false
var reeling: bool = false
var hooked: bool = false
var direction: Vector2 = Vector2.ZERO
var tip_position: Vector2 = Vector2.ZERO
var tip_distance: float
#Exported Variables
@export var speed: float = G.TILE_SIZE / 2.0
#OnReady Variables
@onready var p: CharacterBody2D = get_parent()
@onready var links: Sprite2D = $Links
@onready var tip: CharacterBody2D = $Tip
@onready var grapple_guide: Sprite2D = $GrappleGuideSprite
@onready var grapple_destination: Marker2D = $GrappleGuideSprite/GrappleDestination
#------------------------------------------------------------------------------#
#Physics Process
func _physics_process(_delta: float) -> void:
	var states = p.fsm.states
	if [states.grapple_hooked,
		states.grapple_fire].has(p.fsm.state): grapple_physics()
	else:
		tip.visible = false
		tip.global_position = p.global_position
		links.global_position = p.global_position
		links.region_rect.size.y = 0
#------------------------------------------------------------------------------#
#Grapple Physics
func grapple_physics() -> void:
	tip_distance = p.global_position.distance_to(tip.global_position)
	if !reeling:
		tip.global_position = tip_position
		if flying:
			if tip.move_and_collide(direction * speed):
				hooked = true
				flying = false
				add_point()
			elif tip_distance > p.grapple_length:
				reeling = true
				await get_tree().create_timer(0.1).timeout
				reel()
	tip_position = tip.global_position
	tip.visible = flying || hooked
	links.visible = tip.visible
	if !tip.visible: return
	var tip_loc = to_local(tip_position)
	links.rotation = position.angle_to_point(tip_loc) - deg_to_rad(-90)
	tip.rotation = position.angle_to_point(tip_loc) - deg_to_rad(-90)
	links.position = tip_loc
	links.region_rect.size.y = tip_loc.length()
#------------------------------------------------------------------------------#
#Grapple Functions
#Shoot
func shoot(dir: Vector2) -> void:
	direction = dir.normalized()
	flying = true
	tip_position = global_position
func reel() -> void:
	var tween = create_tween()
	tween.tween_property(tip, "position", Vector2.ZERO, 0.1)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): reeling = false)
	tween.tween_callback(func(): flying = false)
	tween.tween_callback(func(): p.is_grappling = false)
	tween.tween_callback(func(): remove_points())
#Release
func release() -> void:
	flying = false
	hooked = false
#------------------------------------------------------------------------------#
#Add Spring Joint
func add_point() -> void:
	remove_points()
	var point_scene = GRAPPLE_POINT.instantiate()
	point_scene.tip = tip
	point_scene.player = p
	G.ORPHANS.add_child(point_scene)
#Remove Spring Joint
func remove_points() -> void:
	for node in G.ORPHANS.get_children():
		if node.is_in_group("GrapplePoints"): node.queue_free()
