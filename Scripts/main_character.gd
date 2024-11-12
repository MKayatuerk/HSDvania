extends CharacterBody2D


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
@onready var jumpbuffer: Timer = $Jumpbuffer
@onready var coyotee_timer: Timer = $CoyoteeTimer
@onready var player_collision: CollisionShape2D = $CollisionShape2D


### HEALTH ###
var hearts:int = 3
var health:int = 100

#Saves the Velocity of the previous frame
var prevVelocity:Vector2 = Vector2.ZERO

# Checks if the Doublejump upgrade has been collected
var hasDoubleJumpUpgrade:bool = false

# Checks if the character can currently doubleJump
# Only effective when hasDoubleJumpUpgrade = true 
var canDoubleJump:bool = true

# Checks if the character can currently climb
var canClimb:bool = false

#Checks if the character can move. Set to false whilst in the hurt animation
var canMove:bool = true

var isInvincible:bool = false

#Determines if the character stood on the floor in the last frame, used for the
#Coyotee timer
var was_on_floor:bool = true


var lifepoints:int = 3

var boostDirection = 1


func _ready() -> void:
	Signalhive.connect("player_entered",touching_ladder)
	Signalhive.connect("player_exited", leaving_ladder)
	Signalhive.connect("player_damaged", damage_taken)
	Signalhive.connect("entered_stairs", is_on_stairs)
	Signalhive.connect("left_stairs",is_on_stairs)

#Main loop of the character
func _physics_process(delta: float) -> void:
	
	gravity(delta)
	handleJump(delta)
	was_on_floor = is_on_floor()
	handleMovement()
	
	prevVelocity = velocity


# Function that handles the Jump functionality
func handleJump(delta: float)-> void:
	 
	if Input.is_action_just_pressed("jump"):
		jumpbuffer.start(0.10)
		# Check for the diffrent possible cases when pressing jump
		if  is_on_floor():
			velocity.y = jump_velocity
			
		# Handle the double jump
		elif !is_on_floor() and (canCurrentlyDoubleJump() or coyotee_timer.time_left > 0):
			if coyotee_timer.time_left == 0:
				canDoubleJump = false
			velocity.y = jump_velocity
	elif is_on_floor() and (jumpbuffer.time_left > 0):
		velocity.y = jump_velocity
		
	#Allows for variable Jumphight
	elif Input.is_action_just_released("jump"):
		velocity.y *= 0.3
	#Enable double Jump when on the floor
	if(velocity.y == 0):
		canDoubleJump = true





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
	
  	
	if canMove:
		if directionHorizontal:
			velocity.x = directionHorizontal * SPEED
		elif !is_on_floor() and directionHorizontal:
			velocity.x = lerp(prevVelocity.x, velocity.x, 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/2)
			
		if directionVerical and canClimb:
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
		#velocity.y = lerp(prevVelocity.y, velocity.y, 0.8)
		if was_on_floor:
			coyotee_timer.start(0.25)




#Function that returns true if all conditions are met to allow the character
#To double jump
func canCurrentlyDoubleJump() -> bool:
	if hasDoubleJumpUpgrade and canDoubleJump:
		return true
	else:
		return false

##---------------------SIGNALS------------------------------------------------
func _on_area_2d_body_entered(body: Node2D) -> void:
	hasDoubleJumpUpgrade = !hasDoubleJumpUpgrade





func touching_ladder() -> void:
	canClimb = true
	


func leaving_ladder() -> void:
	canClimb = false
	


func _on_invincibilty_timer_timeout() -> void:
	isInvincible = false
	canMove = true
	$Sprite2D.material.set_shader_parameter("mix_color", 0)

func damage_taken(damage_taken) -> void:
	if isInvincible:
		return

	update_health(damage_taken)
	knockback()
	$Sprite2D.material.set_shader_parameter("mix_color", 1)
	
	isInvincible = true
	canMove = false
	inv_timer.start(0.3)
	
func update_health(damage_taken) -> void:
	health -= damage_taken

	if(health <= 0): #ein herz verloren, neue health ist 100
		hearts -= 1
		health = 100
	
	var hud = get_parent().get_node("CanvasLayer/Hud")
	if hud:
		hud.update_health(hearts, health)
		
	if(hearts <= 0): #letztes herz verloren, wir sind tot
		print("Tot")
		
func knockback()-> void:
	if velocity.x >= 0:
		velocity.x = -120
	else:
		velocity.x = 120
	velocity.y = -230

func is_on_stairs(isOnStairs: bool) -> void:
	print(isOnStairs)
	if isOnStairs:
		player_collision.disabled = true
	else:
		player_collision.disabled = false
