#Inherits Area2D Code
extends Area2D
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var anim_player = $AnimationPlayers/AnimationPlayer
#------------------------------------------------------------------------------#
#Body Entered
func _on_body_entered(body):
	if body.name == "Neeq":
		S.set_life_count(+1)
		body.heal(100)
		anim_player.play("obtain")
		await anim_player.animation_finished
		queue_free()
