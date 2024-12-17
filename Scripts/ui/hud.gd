extends  Control

@onready var heart_bar = $HeartBar
@onready var health_bar = $HealthBar

@onready var gameover_sfx = $GameOver/GameoverSfx
@onready var continue_sfx = $ContinueSfx

@onready var bafoeg_text: Label = $BafoegText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhive.connect("player_died", game_over_screen)
	Signalhive.connect("retry", normal_HUD)
	Signalhive.connect("collected_bafoeg", update_bafoeg_text)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health(health):
	
	health_bar.update(health)
	
func game_over_screen() -> void:
	health_bar.visible = false
	bafoeg_text.visible = false
	$GameOver.visible = true
	gameover_sfx.play()


func normal_HUD() -> void:
	health_bar.visible = true
	$GameOver.visible = false
	bafoeg_text.visible = true
	bafoeg_text.text = "Bafög: 0/?"
	GlobalVariables.bafoeg_count = 0
	continue_sfx.play()


func update_bafoeg_text(_pos,_type) -> void:
	if !bafoeg_text.visible:
		bafoeg_text.visible = !bafoeg_text.visible
	GlobalVariables.bafoeg_count += 1
	bafoeg_text.text = str("Bafög: " ,GlobalVariables.bafoeg_count ,"/?")
