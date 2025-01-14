extends Node

var isInGameOverScreen = false

func _ready() -> void:
	Signalhive.connect("player_died",_enter_game_over_screen)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		GlobalVariables.collectedFirstBafoeg = false
		get_tree().change_scene_to_file("res://Scenes/Levels/main_hall.tscn")
	elif event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("ui_accept") and isInGameOverScreen:
		Signalhive.emit_signal("retry")
		Engine.time_scale = 1
		isInGameOverScreen = false
	

func _enter_game_over_screen() -> void:
	isInGameOverScreen = true
