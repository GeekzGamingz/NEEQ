#Inherits Node2D Code
extends Node2D
#------------------------------------------------------------------------------#
#Variables
#Exported Variables
@export_enum("Exclaim", "Question") var emote: String
#OnReady Variables
@onready var anim_player = $AnimationPlayers/AnimationPlayer
@onready var chat_bubble = $ChatBubble
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	if emote != null:
		match(emote):
			"Exclaim": anim_player.play("exclaim")
			"Question": anim_player.play("question")
	await anim_player.animation_finished
	queue_free()
