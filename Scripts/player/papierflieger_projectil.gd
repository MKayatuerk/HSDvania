extends RigidBody2D
class_name httpReq

var direction:int

func set_direction(directionParam:int=1) -> void:
	direction = directionParam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sleeping = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction < 0:
		$Sprite2D.flip_h = true
	apply_force(Vector2(200 * delta * direction, 0))


func _on_body_entered(body: Node) -> void:
	
	if !body.is_class("CharacterBody2D"):
		queue_free()
		Signalhive.emit_signal("request_recieved")
	else:
		
		sleeping = false
		
