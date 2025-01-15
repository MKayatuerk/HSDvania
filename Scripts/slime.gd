extends CharacterBody2D

const SPEED = 50  # Geschwindigkeit des Gegners
const GRAVITY = 500  # Schwerkraft (optional, falls nötig)
var direction = 1  # Richtung des Gegners


@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

signal got_stomped

func _physics_process(delta):
    # Schwerkraft anwenden
    velocity.y += GRAVITY * delta #kann man rauslöschen, but idk falls man mehrer spawnt und die in der luft sind sollen die fallen

    # Bewegung horizontal
    velocity.x = SPEED * direction

    # Kollisionsabfrage mit Raycasts
    if ray_cast_right.is_colliding():
        direction = -1
        animated_sprite.flip_h = true
    elif ray_cast_left.is_colliding():
        direction = 1
        animated_sprite.flip_h = false

    # Bewegung ausführen
    move_and_slide()
    
    


func _on_area_2d_body_entered(body: Node2D) -> void:
    print("Kollidierter Node:", body.name)
    if body is CharacterBody2D:  # Prüft ob es ein Charakter ist
        print("Charakter erkannt!")
        got_stomped.emit()
        queue_free() # slime löschen


func _on_damage_area_body_entered(body: Node2D) -> void:
    pass # Replace with function body.
