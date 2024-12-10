extends  Control

@onready var heart_bar = $HeartBar
@onready var health_bar = $HealthBar

@onready var gameover_sfx = $GameOver/GameoverSfx
@onready var continue_sfx = $ContinueSfx


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhive.connect("player_died", game_over_screen)
	Signalhive.connect("retry", normal_HUD)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health(health):
	
	health_bar.update(health)
	
func game_over_screen() -> void:
	health_bar.visible = false
	$GameOver.visible = true
	gameover_sfx.play()


func normal_HUD() -> void:
	health_bar.visible = true
	$GameOver.visible = false
	continue_sfx.play()
