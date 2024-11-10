extends Area2D




func _on_body_entered(body: Node2D) -> void:
	Signalhive.emit_signal("player_damaged", 10)
