extends CharacterBody2D

class_name MainCharacter

const SPEED = 125.0
const CLIMBING_SPEED = -50


@export var jump_height: float = 60
@export var jump_seconds_to_peak: float = 0.5
@export var jump_seconds_to_descent: float = 0.3

@onready var jump_velocity: float = ((2 * jump_height) / jump_seconds_to_peak) * -1
@onready var jump_gravity: float = ((-2 * jump_height) / pow(jump_seconds_to_peak,2)) * -1
@onready var fall_gravity: float = ((-2 * jump_height) / pow(jump_seconds_to_descent,2)) * -1   

@onready var animationPlayer = $AnimationPlayer
@onready var inv_timer: Timer = $"Invincibilty timer"
@onready var jump_buffer: Timer = $Jumpbuffer
@onready var coyotee_timer: Timer = $CoyoteeTimer


#Saves the Velocity of the previous frame
var prevVelocity:Vector2 = Vector2.ZERO

# Checks if the Doublejump upgrade has been collected
var _has_double_jump_upgrade:bool = false

# Checks if the character can currently doubleJump
# Only effective when _has_double_jump_upgrade = true 
var _can_double_jump:bool = true

# Checks if the character can currently climb
var _can_climb:bool = false

#Checks if the character can move. Set to false whilst in the hurt animation
var _can_move:bool = true

var _is_invincible:bool = false

#Determines if the character stood on the floor in the last frame, used for the
#Coyotee timer
var _was_on_floor:bool = true


var lifepoints:int = 3

var boostDirection = 1


func _ready() -> void:
	#Subscribing to relevant signals
	Signalhive.connect("player_entered",_touching_ladder)
	Signalhive.connect("player_exited", _leaving_ladder)
	Signalhive.connect("player_damaged", _damage_taken)
	Signalhive.connect("transport_player", _move_through_door)
	Signalhive.connect("collected_Bafoeg", _collected_bafoeg)
	Signalhive.connect("collected_double_jump",_collected_double_jump)

#Main loop of the character
func _physics_process(delta: float) -> void:
	
	gravity(delta)
	handleJump(delta)
	_was_on_floor = is_on_floor()
	handleMovement()
	
	prevVelocity = velocity


# Function that handles the Jump functionality
func handleJump(delta: float)-> void:
	 
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start(0.10)
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
		$Sprite2D.flip_h = false
		boostDirection = 1
	elif (directionHorizontal < 0):
		$Sprite2D.flip_h = true
		boostDirection = -1
	
  	
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
		velocity.x = 400 * boostDirection
	
	move_and_slide()
	update_animations(directionHorizontal)
	




# Function that fires the walking animation of the player upon walking
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Walk")
	else:
		pass


func gravity(delta:float):
		# Add the gravity
	if  not is_on_floor():
		if velocity.y < 0:
			velocity.y += jump_gravity * delta
		else:
			velocity.y += fall_gravity * delta
		
		if _was_on_floor:
			coyotee_timer.start(0.10)




#Function that returns true if all conditions are met to allow the character
#To double jump
func canCurrentlyDoubleJump() -> bool:
	if _has_double_jump_upgrade and _can_double_jump:
		return true
	else:
		return false

##---------------------SIGNALS------------------------------------------------


func _collected_double_jump() -> void:
	print("yooo")
	_has_double_jump_upgrade = true


func _touching_ladder() -> void:
	_can_climb = true
	


func _leaving_ladder() -> void:
	_can_climb = false
	


func _on_invincibilty_timer_timeout() -> void:
	_can_move = true
	_is_invincible = false



func _damage_taken() -> void:
	if !_is_invincible:
		_is_invincible = true
		_can_move = false
		lifepoints -= 1
		if velocity.x >= 0:
			velocity.x = -120
		else:
			velocity.x = 120
		velocity.y = -230
		inv_timer.start(0.3)
	

func _collected_bafoeg() -> void:
	print("yippie")

func _move_through_door(newPos: Vector2) -> void:
	position = newPos
