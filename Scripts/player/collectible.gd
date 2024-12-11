extends Node2D

class_name Collectible  # This allows other scripts to reference Collectible

var item_name: String = "Generic Collectible"
var description: String = "An item."
var icon: Texture
var has_glow: bool = true

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var glow: GPUParticles2D = $Area2D/ParticleViewport/Glow

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		collect()

func collect() -> void:
	Signalhive.emit_signal("collected", self)
	$AudioStreamPlayer.play()
	if glow:
		glow.emitting = false
