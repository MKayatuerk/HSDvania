extends Area2D


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up") and has_overlapping_bodies():
		get_tree().change_scene_to_file("res://Scenes/awsome_creditsroom.tscn")
