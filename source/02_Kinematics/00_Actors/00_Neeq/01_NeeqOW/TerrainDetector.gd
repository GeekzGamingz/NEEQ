#Inherits Area2D Code
extends Area2D
#------------------------------------------------------------------------------#
#Variables
var biome: String
var current_tilemap: TileMap
#------------------------------------------------------------------------------#
#On Body Shape Entered
func _on_body_shape_entered(body_rid: RID,
	body: Node2D,
	_body_shape_index: int,
	_local_shape_index: int) -> void:
		if body is TileMap:
			_process_tilemap_collision(body, body_rid)
#------------------------------------------------------------------------------#
func _process_tilemap_collision(body: Node2D, body_rid: RID) -> void:
	current_tilemap = body
	var tile_position = current_tilemap.get_coords_for_body_rid(body_rid)
	for index in current_tilemap.get_layers_count():
		var tile_data = current_tilemap.get_cell_tile_data(index, tile_position)
		if !tile_data is TileData:
			continue
		biome = tile_data.get_custom_data_by_layer_id(0)
