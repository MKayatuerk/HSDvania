extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().change_scene_to_file("res://Scenes/Levels/main_hall.tscn")
	elif event.is_action_pressed("quit"):
		get_tree().quit()
