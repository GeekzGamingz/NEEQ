#Inherits GPUParticles2D Code
extends GPUParticles2D
#------------------------------------------------------------------------------#
#Variables
#------------------------------------------------------------------------------#
#Ready Function
func _ready():
	emitting = true
#------------------------------------------------------------------------------#
#On Finished Emitting
func _on_finished():
	queue_free()
