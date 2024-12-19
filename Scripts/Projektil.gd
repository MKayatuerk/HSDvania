extends Area2D

@export var speed: float = 50
var direction: Vector2 = Vector2.ZERO  # Standard Richtung

func _ready():
    #connect("area_entered", _on_body_entered)
    pass

func _process(delta):
    global_position += direction * speed * delta




func _on_body_entered(body: Node2D) -> void:
    print("onbodyenterd")
    if body.name == "MainCharacter":  # Spieler-Node erkennen
            #area.queue_free()  # Optional: Spieler Schaden zufügen oder andere Logik
            queue_free()  # Projektil zerstören nach Kollision
        
