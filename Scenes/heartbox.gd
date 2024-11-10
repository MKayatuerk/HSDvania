extends HBoxContainer

var heart_full = preload("res://Assets/heart_full.png")
var heart_empty = preload("res://Assets/heart_empty.png")
var heart_half = preload("res://Assets/heart_half.png")

func update_simple(value):
	for i in get_child_count():
		get_child(i).visible = value > i
		
func update_empty(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_empty

func update_partial(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
