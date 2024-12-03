extends CharacterBody2D
var chaseSpeed = 100
var path_speed = 0.1
var player : Node2D = null
@export var path: Path2D = null;
var path_follow_2D : PathFollow2D = null;
@onready var path_follow_2d: PathFollow2D = $PathFollow2D

func _ready():
	# mit getTree den player suchen
	player = get_tree().current_scene.get_node("../MainCharacter") as Node2D  
	if player == null:
		print("player not found")
		
	#path_follow_2D = path.get_node("PathFollow2D")


func _physics_process(delta : float):
	if player != null :
		#hol dir die position des spielers
		var playerPos = player.global_position
		var distanceToPlayer = global_position.distance_to(playerPos)
		#verfolge ihn wenn er in einer bestimmten range ist 
		if distanceToPlayer <= 175:
			print("chasing player")
			var direction = (playerPos - global_position).normalized() # lauf auf ihn zu 
			velocity = direction * chaseSpeed
			#path_follow_2D.unit_offset = 0 
		else: # ist er nicht in der range lauf den path entlang in einer bestimmten geschwindigkeit
			path_follow_2D.progress_ratio += delta * path_speed
			var path_target_pos = path_follow_2D.get_global_transform().origin
			var direction_to_path = (path_target_pos - global_position).normalized()
			velocity = direction_to_path * chaseSpeed
	
	move_and_slide() # der gegner slidet automatisch an oberflächen 

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
