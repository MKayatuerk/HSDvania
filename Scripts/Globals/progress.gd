extends Node

var already_collected_list = []
var tilemap:TileMapLayer
var BafoegCount = 0

var doubleJumpCollected = false:
	set(val):
		if !doubleJumpCollected:
			doubleJumpCollected = val

var messageCollected = false:
	set(val):
		messageCollected = val


func _ready() -> void:
	Signalhive.connect("tilemap_send", set_tilemap)
	Signalhive.connect("collected_bafoeg",add_to_collected_list)
	Signalhive.connect("collected_double_jump", add_to_collected_list)
	




func add_to_collected_list(tile_cord:Vector2, type: int) -> void:
	
	match type:
		1:
			pass
		2:
			doubleJumpCollected = true
	already_collected_list.append(tile_cord)
	print(already_collected_list)
	
	
func clear_collected_tiles() -> void:
	for i in already_collected_list:
		tilemap.set_cell(already_collected_list[i],-1)
		

func set_tilemap(incoming_tilemap) -> void:
	if tilemap == null:
		tilemap = incoming_tilemap
