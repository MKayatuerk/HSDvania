extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0

func set_health(_health):
	var prev_health = health
	health = clamp(_health, 0, max_value)  # Set health within the bounds of 0 and max_value
	value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
