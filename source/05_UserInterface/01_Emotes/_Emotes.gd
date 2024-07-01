#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export var ui_emote: bool = false
@export_enum(
	"Exclaim",
	"Question",
	"Interrobang",
	"Lick",
	"Lick_Neeq",
	"Love"
	) var emote: String
#OnReady Variables
@onready var chat_bubble: Sprite2D = $ChatBubble
@onready var emote_range: CollisionShape2D = $EmoteRange/CollisionShape2D
@onready var anim_player: AnimationPlayer = $AnimationPlayers/AnimationPlayer
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	if ui_emote == true:
		emote_range.set_deferred("disabled", true)
		emote_range.set_deferred("visible", false)
		var anim_names = anim_player.get_animation_list()
		for anim in anim_names:
			anim_player.get_animation(anim).loop = true
	if emote != null:
		match(emote):
			"Exclaim": anim_player.play("exclaim")
			"Question": anim_player.play("question")
			"Interrobang": anim_player.play("interrobang")
			"Lick": anim_player.play("lick")
			"Lick_Neeq": anim_player.play("lick_neeq")
			"Love": anim_player.play("love")
	await anim_player.animation_finished
	queue_free()
