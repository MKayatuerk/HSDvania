extends Control

@onready var health_bar = $Healthbar
@onready var heart_bar = $Heartbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.init_health(100)
	Signalhive.connect("player_damaged", on_player_damaged)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_player_damaged(damage_taken):
	heart_bar.update_partial(3)
	health_bar.set_health(damage_taken)
	print(damage_taken)
