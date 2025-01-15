extends Control

@export var overlay: CanvasLayer
@onready var menu_sound: AudioStreamPlayer = $Overlay/Back/MenuSound


func _ready() -> void:
	overlay.visible = false
	$Overlay/VBoxContainer/MasterVolume.value = GlobalVariables.master_volume

func _on_master_volume_value_changed(value: float) -> void:
	GlobalVariables.master_volume = value
	menu_sound.play()

func ToggleVisibility(state: bool) -> void:
	visible = state
	overlay.visible = state


func _on_back_pressed() -> void:
	GlobalVariables.paused = false
	ToggleVisibility(false)


func _on_back_mouse_entered() -> void:
	menu_sound.play()
