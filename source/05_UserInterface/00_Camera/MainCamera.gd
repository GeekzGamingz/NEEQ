#Inherits Camera2D Code
extends Camera2D
#------------------------------------------------------------------------------#
#Constants
const LOOK_FACTOR = 0.1
#------------------------------------------------------------------------------#
#Variables
var facing = 0
#Exported Variable
@export var panning_duration: float = 1.0
#OnReady Variables
@onready var p = get_parent()
@onready var prev_cam_position: Vector2 = get_screen_center_position()
#------------------------------------------------------------------------------#
#Ready
func _ready() -> void:
	G.DEBUG.camera = self
#------------------------------------------------------------------------------#
func _process(_delta) -> void:
	check_facing()
	prev_cam_position = get_screen_center_position()
	if p.name == "Neeq":
		drag_vertical_enabled = !p.is_on_floor() #Bypass Raycasts
#------------------------------------------------------------------------------#
#Panning
func set_panning(t: int, b: int, l: int, r: int) -> void:
	limit_top = t
	limit_bottom = b
	limit_left = l
	limit_right = r
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
