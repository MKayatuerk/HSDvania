extends HBoxContainer

var heart_full = preload("res://Assets/heart_full.png")
var heart_empty = preload("res://Assets/heart_empty.png")
var heart_half = preload("res://Assets/heart_half.png")

func update(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
