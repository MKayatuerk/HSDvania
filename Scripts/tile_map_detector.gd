extends Node

var tilemap: TileMapLayer

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		tilemap = body
		var collided_tile_cord = tilemap.get_coords_for_body_rid(body_rid)
		var tile_data = tilemap.get_cell_tile_data(collided_tile_cord)
		if tile_data:
			if tile_data.get_custom_data("Danger"):
				Signalhive.emit_signal("player_damaged", 10)
				
			if tile_data.get_custom_data("PickUp") == 1:
				tilemap.set_cell(collided_tile_cord,-1)
				Signalhive.emit_signal("collected_bafoeg")
			elif tile_data.get_custom_data("PickUp") == 2:
				print("hey")
				tilemap.set_cell(collided_tile_cord,-1)
				Signalhive.emit_signal("collected_double_jump")
