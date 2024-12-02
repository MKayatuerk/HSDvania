extends Node2D

@export var leading_to:PackedScene
@export_file var test
@export var leading_to_name: String = "narnia"


func _ready() -> void:
    $Label.text = leading_to_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("up") and $Area2D.has_overlapping_bodies():
        print("go")
        #get_tree().change_scene_to_packed(leading_to)
        get_tree().change_scene_to_file(test)
