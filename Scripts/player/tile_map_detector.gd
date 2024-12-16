extends Node
@onready
var item_collected_sfx = $itemCollectedSfx
@onready
var paper_collected_sfx = $PaperCollectedSfx
@onready
var damage_sfx = $DamageSfx

var tilemap: TileMapLayer

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("test")
	if body is TileMapLayer:
		tilemap = body
		var collided_tile_cord = tilemap.get_coords_for_body_rid(body_rid)
		var tile_data = tilemap.get_cell_tile_data(collided_tile_cord)
		if tile_data:
			if tile_data.get_custom_data("Danger"):
				damage_sfx.play()
				Signalhive.emit_signal("player_damaged", 30)
			if tile_data.get_custom_data("PickUp") == 1:
				tilemap.set_cell(collided_tile_cord,-1)
				paper_collected_sfx.play()
				Signalhive.emit_signal("collected_bafoeg",collided_tile_cord,1)
			elif tile_data.get_custom_data("PickUp") == 2:
				print("hey")
				tilemap.set_cell(collided_tile_cord,-1)
				item_collected_sfx.play()
				Signalhive.emit_signal("collected_double_jump",collided_tile_cord,2)
			if tile_data.get_custom_data("IsOnStair"):
				Signalhive.emit_signal("entered_stairs",true)
			else: 
				Signalhive.emit_signal("left_stairs",false)
