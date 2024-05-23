#Inherits Control Code
extends Control
#------------------------------------------------------------------------------#
#Variables
#OnReady Variables
@onready var health_under = $Health/HealthUnder
@onready var health_over = $Health/HealthOver
#------------------------------------------------------------------------------#
#Health Updater
#Heal
func health_heal(health):
	health_under.value = health
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(health_over, "value", health, 2)
	tween.tween_property(health_under, "value", health, 1)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.play()
#Damage
func health_damage(health):
	health_over.value = health
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(health_over, "value", health, 1)
	tween.tween_property(health_under, "value", health, 2)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.play()
#Max Health Updater
func max_health_updater(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health
