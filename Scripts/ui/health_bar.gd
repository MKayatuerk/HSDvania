extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 100


func _ready() -> void:
	max_value = 100
	value = health
	damage_bar.max_value = max_value
	damage_bar.value = health


func update(_health):
	var prev_health = health
	health = clamp(_health, 0, max_value)
	
	value = health
	
	#if health <= 0:
	#	queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

# Called when the node enters the scene tree for the first time.


func _on_timer_timeout() -> void:
	damage_bar.value = health
