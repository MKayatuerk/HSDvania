extends Node


var spawnable = preload("res://Scenes/Geometry/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Signalhive.emit_signal("entered_cutsene")
	Signalhive.emit_signal("queued_message","Wha... what?")
	Signalhive.emit_signal("queued_message","What happened? Where am I?")
	Signalhive.emit_signal("queued_message","I remember falling asleep during class... but...")
	Signalhive.emit_signal("queued_message","Is this really the HSD? It looks different somehow...")
	
	
	Signalhive.connect("heart_demanded",spawn_heart)


func spawn_heart(pos: Vector2):
	var spawned_item: Node2D = spawnable.instantiate()
	spawned_item.position = pos
	add_child(spawned_item)
