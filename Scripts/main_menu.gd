extends Control
@onready
var ui_hover_sound = $UI/MarginContainer/VBoxContainer/UiHoverSfx
@onready
var gong_sound = $UI/MarginContainer/VBoxContainer/GongSfx
@onready
var hsdvania_sfx = $UI/MarginContainer/VBoxContainer/HsdVaniaSfx

func _on_spielen_pressed() -> void:
	gong_sound.play()
	hsdvania_sfx.play()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/main_hall.tscn")


func _on_optionen_pressed() -> void:
	$Settings.ToggleVisibility(true)

func _on_beenden_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animated_sprite_2d_ready() -> void:
	$UI/MarginContainer/Occluder/CharacterSprite.play("default")


func _on_spielen_mouse_entered() -> void:
	ui_hover_sound.play()


func _on_optionen_mouse_entered() -> void:
	ui_hover_sound.play()


func _on_beenden_mouse_entered() -> void:
	ui_hover_sound.play()
