extends Node2D

const SPEED = 60

var direction = 1 

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# Called every frame.
#'delta' ist die zeit zum letzten frame
func _process(delta):
	#for every frame we check if the enemy is colliding with a block
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

		
		
		# 60 pixel(speed konstante) pro sekunde
	position.x += direction * SPEED * delta 
