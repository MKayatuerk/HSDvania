extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sleeping = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	apply_force(Vector2(200* delta, 0))


func _on_body_entered(body: Node) -> void:
	
	if !body.is_class("CharacterBody2D"):
		queue_free()
		Signalhive.emit_signal("request_recieved")
	else:
		
		sleeping = false
		
