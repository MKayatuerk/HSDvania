extends Node

var tilemap: TileMapLayer

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		tilemap = body
		var collided_tile_cord = tilemap.get_coords_for_body_rid(body_rid)
		var tile_data = tilemap.get_cell_tile_data(collided_tile_cord)
		if tile_data:
			var help = tile_data.get_custom_data("Danger")
			if help:
				Signalhive.emit_signal("player_damaged")
