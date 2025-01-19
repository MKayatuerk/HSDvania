extends CharacterBody2D
const SPEED = 60


var direction = 1 
var player_in_sight: bool = false
var player: Node2D = null

@export var shoot_cooldown: float = 1.5
@export var projectile_scene: PackedScene  # Projektil-Szene
@onready var shoot_timer = $Timer
@onready var shoot_marker = $Marker2D
@export var patrol_speed: float = 100

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_for_exclamation_mark_left: RayCast2D = $RayCastForExclamationMarkLeft
@onready var ray_cast_for_exclamation_mark_right: RayCast2D = $RayCastForExclamationMarkRight



func _ready():
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.connect("timeout", _shoot)



# Called every frame.
func _process(delta):
	# Check for collisions and flip direction
   # if ray_cast_right.is_colliding():
	   # direction = -1
		#animated_sprite.flip_h = true
   # if ray_cast_left.is_colliding():
	  #  direction = 1
	  #  animated_sprite.flip_h = false

 #   position.x += direction * SPEED * delta

	# Show exclamation mark if the player is in range
	if ray_cast_for_exclamation_mark_left.is_colliding() or ray_cast_for_exclamation_mark_right.is_colliding():
		$Exclamationmark.visible = true
		$AnimatedSprite2D.play("shooting")
	else:
		$Exclamationmark.visible = false 
		patrol(delta)
		
		
func patrol(delta):
	$AnimatedSprite2D.play("Walking")
	velocity.x = patrol_speed * direction
	move_and_slide()

	# Richtungswechsel prüfen
	if is_on_wall():
		direction *= -1
		scale.x *= -1  # Gegner spiegeln*= -1
		
		
	  #
#func _on_area2d_body_entered(body):
	#if body.name == "Player":
		#player_in_sight = true
		#player = body
		#shoot_timer.start()
		#
#func _on_area2d_body_exited(body):
	#if body.name == "MainCharacter":
		#player_in_sight = false
		#player = null
		#shoot_timer.stop()
	#
		
		
func _shoot():
	print("Shoot function triggered")# debug zwecke
	if player_in_sight and player:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = shoot_marker.global_position
		# Richtung zum Spieler berechnen
		var shoot_direction = (player.global_position - global_position).normalized()
		animated_sprite_2d.flip_h = (shoot_direction.x > 0)
		print(shoot_direction)
		projectile.direction = shoot_direction
		get_parent().add_child(projectile)
		



func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":
		player_in_sight = true
		player = body
		print("Player in sight")
		shoot_timer.start()
		print("Shoot Timer started")
		  # Drehen des Professors in Richtung des Spielers
		#if player.global_position.x > global_position.x:
		 #   direction = 1  # Spieler ist rechts
		#else:
		#    direction = -1  # Spieler ist links

		#scale.x = abs(scale.x)*direction  # Sprite spiegel



func _on_area_2d_2_body_exited(body: Node2D) -> void: if body.name == "MainCharacter":
		player_in_sight = false
		player = null
		shoot_timer.stop()
