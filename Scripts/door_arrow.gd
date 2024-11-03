extends Area2D


var movement = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#position.y += movement
	#
	#if position.y > 10:
		#movement *= -1
	#elif position.y < 4:
		#movement *= -1



func _on_body_entered(body: Node2D) -> void:
	$"../Arrow".visible = true
	$"../Label".visible = true


func _on_body_exited(body: Node2D) -> void:
	$"../Arrow".visible = false
	$"../Label".visible = false
