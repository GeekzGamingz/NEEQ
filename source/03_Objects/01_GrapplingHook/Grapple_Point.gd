#Inherits StaticBody2D Code
extends StaticBody2D
#------------------------------------------------------------------------------#
#Variables
var player: CharacterBody2D
var tip: CharacterBody2D
#OnReady Variables
@onready var player_holder: RigidBody2D = $PlayerHolder
@onready var grapple_spring = $GrappleSpring
#------------------------------------------------------------------------------#
#Ready Method
func _ready() -> void:
	global_position = tip.global_position
	grapple_spring.length = player.grapple_length
	grapple_spring.rest_length = player.grapple_length / 2.0
	player_holder.global_position = player.grapple.global_position
	player_holder.linear_velocity.x = player.velocity.x
#------------------------------------------------------------------------------#
#Process Function
func _physics_process(_delta) -> void:
	var player_state = player.fsm.states
	if ![player_state.grapple_hooked,
		player_state.grapple_charge_walk,
		player_state.grapple_charge_run,
		player_state.grapple_charge_air,
		player_state.grapple_fire].has(player.fsm.state): queue_free()
	if player.fsm.state == player_state.grapple_hooked:
		player.global_position = player_holder.global_position + Vector2(0, G.TILE_SIZE / 4.0)
	if Input.is_action_pressed("move_right"):
		player_holder.linear_velocity.x += player.max_speed * 0.025
	elif Input.is_action_pressed("move_left"):
		player_holder.linear_velocity.x -= player.max_speed * 0.025
	if Input.is_action_pressed("move_up"):
		if grapple_spring.rest_length > -G.TILE_SIZE: grapple_spring.rest_length -= 1
	elif Input.is_action_pressed("move_down"):
		if grapple_spring.rest_length < player.grapple_length - (G.TILE_SIZE):
			grapple_spring.rest_length += 1
	if player.direction > 0: player.set_facing(player.FACING_RIGHT)
	elif player.direction < 0: player.set_facing(player.FACING_LEFT)
#------------------------------------------------------------------------------#
#When Exiting Tree
func _on_tree_exiting() -> void:
	player.velocity.x = player_holder.linear_velocity.x
