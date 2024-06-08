#Inherits Camera2D Code
extends Camera2D
#------------------------------------------------------------------------------#
#Constants
const LOOK_FACTOR: float = 0.1
#------------------------------------------------------------------------------#
#Variables
var facing: int = 0
#Exported Variable
@export var panning_duration: float = 1.0
#OnReady Variables
@onready var p: Node2D = get_parent()
@onready var prev_cam_position: Vector2 = get_screen_center_position()
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	G.DEBUG.camera = self
	set_panning()
#------------------------------------------------------------------------------#
func _process(_delta) -> void:
	check_facing()
	prev_cam_position = get_screen_center_position()
	if p.name == "Neeq":
		drag_vertical_enabled = !p.is_on_floor() #Bypass Raycasts
#------------------------------------------------------------------------------#
#Panning
func set_panning() -> void:
	var tilemaps = get_tree().get_nodes_in_group("TileMaps")
	for tilemap in tilemaps:
		var level_rect = tilemap.get_used_rect()
		limit_top = -800
		limit_bottom = max(level_rect.end.y * tilemap.tile_set.tile_size.y, limit_bottom)
		limit_left = min(level_rect.position.x * tilemap.tile_set.tile_size.x, limit_left)
		limit_right = max(level_rect.end.x * tilemap.tile_set.tile_size.x, limit_right)
#------------------------------------------------------------------------------#
#Facing
func check_facing() -> void:
	var new_facing = sign(get_screen_center_position().x - prev_cam_position.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_FACTOR * facing
		position.x = target_offset
		#Camera Tweening
		var tween = create_tween()
		tween.tween_property(self, "position:x", target_offset, panning_duration)
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.play()
