extends Node2D

@export var leading_to:Vector2
@export var leading_to_name: String = "narnia"
var letThrough = false

func _ready() -> void:
	$"Leading to Label".text = leading_to_name



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("up") and letThrough:
		if letThrough:
			print("go")
			Signalhive.emit_signal("transported_player",leading_to)


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	letThrough = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	letThrough = false
