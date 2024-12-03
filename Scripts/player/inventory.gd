extends Node

var weapon_list
var current_selected = 0


func _ready() -> void:
	weapon_list = get_children(false)
