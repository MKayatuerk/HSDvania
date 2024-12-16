extends Node2D

const SPEED = 100
var direction = -1

signal gotStomped

@onready var health_bar = $Healthbar
@onready var look_left: RayCast2D = $lookLeft
@onready var look_right: RayCast2D = $lookRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if $lookLeft.is_colliding():
        direction = 1
        $Sprite2D.flip_h = true
    elif $lookRight.is_colliding():
        direction = -1
        $Sprite2D.flip_h = false
        
    position.x += SPEED * delta * direction

func _on_area_2d_body_entered(body: Node2D) -> void:
    gotStomped.emit()
    queue_free()
