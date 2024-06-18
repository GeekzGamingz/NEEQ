#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export_enum(
	"Exclaim",
	"Question",
	"Interrobang",
	"Lick",
	"Lick_Neeq") var emote: String
#OnReady Variables
@onready var anim_player: AnimationPlayer = $AnimationPlayers/AnimationPlayer
@onready var chat_bubble: Sprite2D = $ChatBubble
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	if emote != null:
		match(emote):
			"Exclaim": anim_player.play("exclaim")
			"Question": anim_player.play("question")
			"Interrobang": anim_player.play("interrobang")
			"Lick": anim_player.play("lick")
			"Lick_Neeq": anim_player.play("lick_neeq")
	await anim_player.animation_finished
	queue_free()
