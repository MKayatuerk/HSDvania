extends Node2D

var heart
var spawnChance = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_hurtbox_area_entered(area: Area2D) -> void:
	_spawn_heart()
	queue_free()

func _spawn_heart():
	if(spawnChance >= randf()):
		Signalhive.emit_signal("heart_demanded", position)
