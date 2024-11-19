extends Control


func _on_spielen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main_hall.tscn")
	

func _on_optionen_pressed() -> void:
	pass

func _on_beenden_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animated_sprite_2d_ready() -> void:
	$UI/MarginContainer/Occluder/CharacterSprite.play("default")
