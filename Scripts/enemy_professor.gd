extends Node2D

const SPEED = 60
const BULLET_SPEED = 300
const SHOOT_DELAY = 1.5  # Time between shots in seconds

var direction = 1 
var can_shoot = true

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ToPlayer: RayCast2D = $ToPlayer
@onready var bullet_scene: PackedScene = preload("res://Scenes/Bullet.tscn")  # Adjust path as necessary
@onready var player = $"../MainCharacter"
#get_tree().get_nodes_in_group("PlayerGroup")[0]
# Called every frame.
func _process(delta):
	# Check for collisions and flip direction
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta

	# Show exclamation mark if the player is in range
	ToPlayer.target_position = ToPlayer.to_local(player.Hitbox.global_position)
	

	if ToPlayer.is_colliding():
		$Exclamationmark.visible = true
	  #  if can_shoot:
		 #   shoot_bullet()
	else:
		$Exclamationmark.visible = false

## Shooting function
#func shoot_bullet():
	#can_shoot = false
	#animated_sprite.play("shooting")  # Play the shooting animation
#
	## instanz einer bullet
	#if bullet_scene:
		#var bullet = bullet_scene.instantiate()
		#if bullet and bullet is Area2D:
			#get_parent().add_child(bullet)
#
			## setze bullet position and richtung
			#bullet.position = position
			#bullet.direction = direction
		#else:
			#print("Bullet scene is not an Area2D. Check the Bullet.tscn setup.")
#
	## Reset shooting cooldown
	#var timer = Timer.new()
	#timer.wait_time = SHOOT_DELAY
	#timer.one_shot = true
   ## timer.connect("timeout", self, "_reset_can_shoot") -> throws error
	#add_child(timer)
	#timer.start()
#
#func _reset_can_shoot():
	#can_shoot = true
