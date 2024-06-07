#Inherits Sprite2D Code
extends Sprite2D
#------------------------------------------------------------------------------#
#On Animation Finished
func _on_animation_finished(anim_name):
	if anim_name == "impact": queue_free()
