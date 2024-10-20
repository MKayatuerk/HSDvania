extends Sprite2D


var movement = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += movement
	
	if position.y > 10:
		movement *= -1
	elif position.y < 4:
		movement *= -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	visible = false
