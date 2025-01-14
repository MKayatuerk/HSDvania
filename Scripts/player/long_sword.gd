extends Collectible

class_name Weapon

@onready var rigid_body_2d: RigidBody2D = $RigidBody2D
@onready var rigid_body_collision_shape_2d: CollisionShape2D = $RigidBody2D/RigidBodyCollisionShape2D

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	super._ready()
	item_name = "Lineal"
