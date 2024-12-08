extends CharacterBody2D
var chaseSpeed = 100
var path_speed = 0.1
var player : Node2D = null
@export var path: Path2D = null;
var path_follow_2D : PathFollow2D = null;
@onready var path_follow_2d: PathFollow2D = $PathFollow2D



func _ready():
    global_position = Vector2(415, 458)  # Stelle sicher, dass diese Position sichtbar ist
    print("Schrifttrolle positioniert bei: ", global_position)
    print("fliegendschriftrolle is ready at position: ", global_position)
    # Mit getTree den Player suchen
    player = get_node("../TestCharacter") as Node2D
   # player = get_tree().root.get_node("TestCharacter") as Node2D
    if player == null:
        print("player not found")
    if path == null:
        print("path is null, weise im inspektor zu")
    path_follow_2D = path.get_node("PathFollow2D")


 
func _physics_process(delta: float):
    if player != null:
        # Hol dir die Position des Spielers
        var playerPos = player.global_position
        var distanceToPlayer = global_position.distance_to(playerPos)
        # Verfolge ihn, wenn er in einer bestimmten Range ist
        if distanceToPlayer <= 175:
            print("chasing player")
            var direction = (playerPos - global_position).normalized() # Lauf auf ihn zu
            velocity = direction * chaseSpeed
        else:  # Ist er nicht in der Range, lauf den Path entlang in einer bestimmten Geschwindigkeit
            path_follow_2D.progress_ratio += delta * path_speed
            var path_target_pos = path_follow_2D.get_global_transform().origin
            var direction_to_path = (path_target_pos - global_position).normalized()
            velocity = direction_to_path * chaseSpeed

    move_and_slide() # Der Gegner slidet automatisch an Oberflächen

#
#
#func pause():
    #set_physics_process(false)
    #get_node("../Player").pause()
    #
#
#func unpause():
    #set_physics_process(true)
    #get_node("../Player").play()
