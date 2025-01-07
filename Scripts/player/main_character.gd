extends CharacterBody2D

class_name MainCharacter

const SPEED = 125.0
const CLIMBING_SPEED = -50


@export var jump_height: float = 60
@export var jump_seconds_to_peak: float = 0.5
@export var jump_seconds_to_descent: float = 0.3
@export var setting_screen: Control

@onready var jump_velocity: float = ((2 * jump_height) / jump_seconds_to_peak) * -1
@onready var jump_gravity: float = ((-2 * jump_height) / pow(jump_seconds_to_peak,2)) * -1
@onready var fall_gravity: float = ((-2 * jump_height) / pow(jump_seconds_to_descent,2)) * -1   

@onready var animation_player = $SubViewportContainer/SubViewport/Avatar/AnimationPlayer
@onready var sprite_2d = $SubViewportContainer/Sprite2D

@onready var inv_timer: Timer = $"Invincibilty timer"
@onready var jump_buffer: Timer = $Jumpbuffer
@onready var coyotee_timer: Timer = $CoyoteeTimer
@onready var player_collision = $CollisionShape2D

@onready var pause_sfx = $Settings/PauseSfx
@onready var continue_sfx = $Settings/ContinueSfx
@onready var door_sfx = $DoorSfx
@onready var jumping_sfx = $JumpingSfx
@onready var attack1_sfx = $Attack1Sfx
@onready var attack2_sfx = $Attack2Sfx
@onready var attack3_sfx = $Attack3Sfx




var health:int = 100

var selected_weapon:int = 0

#Saves the Velocity of the previous frame
var prevVelocity:Vector2 = Vector2.ZERO
var prevDirection = 0

#Checks if the Doublejump upgrade has been collected
var _has_double_jump_upgrade:bool = false

# Checks if the character can currently doubleJump
# Only effective when _has_double_jump_upgrade = true 
var _can_double_jump:bool = true

# Checks if the character can currently climb
var _can_climb:bool = false

#Checks if the character can move. Set to false whilst in the hurt animation
var _can_move:bool = true

var _is_invincible:bool = false

var _is_in_cutscene:bool = false

#Determines if the character stood on the floor in the last frame, used for the
#Coyotee timer
var _was_on_floor:bool = true

var _can_attack:bool = true
var _can_request:bool = true


var direction = 1

var shortsword = preload("res://Scenes/Player/shortsword.tscn")
var flieger = preload("res://Scenes/Player/papierfliegerProjectil.tscn")

var animation: Tween

var current_weapon


func _ready() -> void:
	#Subscribing to relevant signals
	Signalhive.connect("collected",_collected)
	Signalhive.connect("weapon_equipped",_weapon_equipped)
	Signalhive.connect("weapon_dropped",_weapon_dropped)
	
	Signalhive.connect("player_entered",_touching_ladder)
	Signalhive.connect("player_exited", _leaving_ladder)
	Signalhive.connect("player_damaged", _damage_taken)
	Signalhive.connect("player_healed", _damage_healed)
	
	Signalhive.connect("transported_player", _move_through_door)
	Signalhive.connect("retry", _retry)
	
	Signalhive.connect("collected_bafoeg", _collected_bafoeg)
	Signalhive.connect("collected_double_jump",_collected_double_jump)
	
	Signalhive.connect("entered_cutsene", _lock_movement)
	Signalhive.connect("exited_cutscene", _unlock_movement)
	
	Signalhive.connect("entered_stairs", is_on_stairs)
	Signalhive.connect("left_stairs", is_on_stairs)
	Signalhive.connect("request_recieved", await_request)
	

func _collected(collectible: Collectible)-> void:
	print("Collected item: ", collectible.item_name)
	$Inventory.add(collectible)
	
func _weapon_equipped(new_weapon: Weapon) -> void:
	print("_weapon_equipped")
	if new_weapon.get_parent():
		new_weapon.get_parent().remove_child(new_weapon)
		
	$WeaponSocket.add_child(new_weapon)
	new_weapon.position = Vector2.ZERO


func _weapon_dropped(old_weapon: Weapon) -> void:
	print("_weapon_dropped")
	if old_weapon.get_parent():
		old_weapon.get_parent().remove_child(old_weapon)
	
	get_tree().root.add_child(old_weapon)
	old_weapon.position = $WeaponSocket.global_position


#Main loop of the character
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GlobalVariables.paused = !GlobalVariables.paused
		if GlobalVariables.paused:
			pause_sfx.play()
		else:
			continue_sfx.play()
		setting_screen.ToggleVisibility(GlobalVariables.paused)
	
	if !GlobalVariables.paused:
		if !_is_in_cutscene:
			gravity(delta)
			handleJump(delta)
			_was_on_floor = is_on_floor()
			handleMovement()
			attack()
			prevVelocity = velocity
			prevDirection = direction


# Function that handles the Jump functionality
func handleJump(delta: float)-> void:
	 
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start(0.10)
		jumping_sfx.play()
		animation_player.play("Jumping")
		# Check for the diffrent possible cases when pressing jump
		if  is_on_floor():
			velocity.y = jump_velocity
			
		# Handle the double jump
		elif !is_on_floor() and (canCurrentlyDoubleJump() or coyotee_timer.time_left > 0):
			if coyotee_timer.time_left == 0:
				_can_double_jump = false
			velocity.y = jump_velocity
	elif is_on_floor() and (jump_buffer.time_left > 0):
		velocity.y = jump_velocity
		
	#Allows for variable Jumphight
	elif Input.is_action_just_released("jump"):
		velocity.y *= 0.3
	#Enable double Jump when on the floor
	if(velocity.y == 0):
		_can_double_jump = true





func handleMovement()-> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionHorizontal = Input.get_axis("left", "right")
	var directionVerical = Input.get_axis("down","up")
	
	
	
	if (directionHorizontal > 0):
		sprite_2d.flip_h = false
		$WeaponSocket.position = Vector2(abs($WeaponSocket.position.x), $WeaponSocket.position.y)
		$WeaponSocket.scale.x = abs($WeaponSocket.scale.x) 
		direction = 1
		
	elif (directionHorizontal < 0):
		sprite_2d.flip_h = true
		$WeaponSocket.position = Vector2(-abs($WeaponSocket.position.x), $WeaponSocket.position.y)
		$WeaponSocket.scale.x = -abs($WeaponSocket.scale.x) 
		direction = -1
	#
	#if (prevDirection != direction):
		#cancelAttack()
	  
	if _can_move:
		if directionHorizontal:
			velocity.x = directionHorizontal * SPEED
		elif !is_on_floor() and directionHorizontal:
			velocity.x = lerp(prevVelocity.x, velocity.x, 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/2)
			
		if directionVerical and _can_climb:
			velocity.y = directionVerical * CLIMBING_SPEED
	
	if Input.is_key_label_pressed(KEY_Z):
		httpRequest()
	
	move_and_slide()
	update_animations(directionHorizontal)
	




# Function that fires the walking animation of the player upon walking
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			animation_player.play("Idle")
		else:
			animation_player.play("Walking")
	else:
		pass



func _damage_healed(damage_healed) -> void:
	update_health(-damage_healed)
	

func _damage_taken(damage_taken) -> void:
	if _is_invincible:
		return
		
	knockback()
	update_health(damage_taken)
	
	sprite_2d.material.set_shader_parameter("is_hit", true)
	
	_is_invincible = true
	_can_move = false
	inv_timer.start(0.3)


func update_health(damage_taken) -> void:
	if(health - damage_taken <= 0):
		_game_over()
		
	else:
		health = min(100, health - damage_taken)
		var hud = get_parent().get_node("CanvasLayer/Hud")
		if hud:
			hud.update_health(health)


func gravity(delta:float):
		# Add the gravity
	if  not is_on_floor():
		if velocity.y < 0:
			velocity.y += jump_gravity * delta
		else:
			velocity.y += fall_gravity * delta
		
		if _was_on_floor:
			coyotee_timer.start(0.10)

func attack() -> void:
	if Input.is_action_just_pressed("attack") and _can_attack:
		handleAttackSound().play()
		add_child(_instantiate_weapon(), true)
		
		current_weapon = get_child(-1)
		current_weapon.position.y = 10
		animation = get_tree().create_tween()
		animation.connect("finished", _attack_tween_finished)
		
		if !_can_attack:
			return
		else:
			_can_attack = false
			animation.tween_property(current_weapon, "position:x" , direction * 12, 0.5)
			animation.tween_property(current_weapon, "position:x" , 0, 0.7)
			animation.tween_callback(current_weapon.queue_free)

func httpRequest() -> void:
	if _can_request:
		
		animation = get_tree().create_tween()
		var httpRequest:httpReq = flieger.instantiate()
		httpRequest.set_direction(direction)
		move_child(httpRequest, 1)
		
		_can_request = false
		if is_on_floor():
			animation.tween_property(self, "velocity:y", -120, 0.1)
			animation.set_parallel()
		animation.tween_callback(add_child.bind(httpRequest))
		animation.set_parallel()
		animation.tween_property(httpRequest,"position:y", 15, 0)
			##animation.tween_callback(move_child.bind(httpRequest,1))
		
		##get_child(1).position.y = 25
		
		

#Function that returns true if all conditions are met to allow the character
#To double jump
func canCurrentlyDoubleJump() -> bool:
	if _has_double_jump_upgrade and _can_double_jump:
		return true
	else:
		return false



func _collected_double_jump(_pos, _type) -> void:
	
	Signalhive.emit_signal("queued_message","I found the Dual-Core boots!")
	Signalhive.emit_signal("queued_message","With the power of multithreading, i can split the legwork to jump,  effectivly letting me double jump!")
	_has_double_jump_upgrade = true

func _collected_bafoeg(_pos, _type) -> void:
	pass

func _touching_ladder() -> void:
	_can_climb = true
	


func _leaving_ladder() -> void:
	_can_climb = false
	

func _move_through_door(newPos: Vector2) -> void:
	door_sfx.play()
	print(newPos)
	position = newPos

func _on_invincibilty_timer_timeout() -> void:
	_can_move = true
	_is_invincible = false
	sprite_2d.material.set_shader_parameter("is_hit", false)


	


func knockback()-> void:
	
	if velocity.x >= 0:
		velocity.x = -120
	else:
		velocity.x = 120
	velocity.y = -230
	

func _retry() -> void:
	health = 100
	position = Vector2(20,-24)
	velocity = Vector2.ZERO
	_damage_healed(100)
	if $gameovertimer.time_left > 0:
		$gameovertimer.stop()
	_unlock_movement()
	if GlobalVariables.didntDieBefore:
		GlobalVariables.didntDieBefore = false
		Signalhive.emit_signal("queued_message","Wh-what just happened?")
		Signalhive.emit_signal("queued_message","Everything just went black... But i think im alright now")
		if GlobalVariables.collectedFirstBafoeg:
			Signalhive.emit_signal("queued_message","OH SHOOT! I lost my Bafoeg documents. I got to collect them again!")
func _game_over() -> void:
	
	Signalhive.emit_signal("player_died")
	Engine.time_scale = 0.3
	$gameovertimer.start(0.7)

	
func _lock_movement() -> void:
	_is_in_cutscene = true
	animation_player.play("Idle")
	
	
func _unlock_movement()-> void:
	_is_in_cutscene = false
	


func _on_gameovertimer_timeout() -> void:
	_lock_movement()
	

func _attack_tween_finished():
	_can_attack = true


func _instantiate_weapon() -> Node2D:
	var weapon_instance = shortsword.instantiate()
	return weapon_instance


func cancelAttack():
	if animation:
		animation.kill()
		current_weapon.queue_free()
		_can_attack = true


func await_request():
	_can_request = true

func is_on_stairs(isOnStairs: bool) -> void:
	if isOnStairs:
		player_collision.disabled = true
		player_collision.set_deferred("disabled",true)
	else:
		player_collision.disabled = false
		player_collision.set_deferred("disabled",false)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Throw":
		print("lol")
	else:
		print("lmao")

func handleAttackSound() -> AudioStreamPlayer:
	var rng = RandomNumberGenerator.new().randi_range(1,3)
	match rng:
		1: return attack1_sfx
		2: return attack2_sfx
		_: return attack3_sfx
