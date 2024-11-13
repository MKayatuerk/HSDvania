extends Control

@onready var heart_bar = $HeartBar
@onready var health_bar = $HealthBar

func update_health(hearts, health):
	heart_bar.update(hearts)
	health_bar.update(health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
