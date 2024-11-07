extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -300.0
const CLIMBING_SPEED = -150



@onready var animationPlayer = $AnimationPlayer
@onready var inv_timer: Timer = $"Invincibilty timer"
@onready var jumpbuffer: Timer = $Jumpbuffer
@onready var coyotee_timer: Timer = $CoyoteeTimer


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



func _ready() -> void:
	Signalhive.connect("player_entered",touching_ladder)
	Signalhive.connect("player_exited", leaving_ladder)
	Signalhive.connect("player_damaged", damage_taken)

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
			velocity.y = JUMP_VELOCITY
			
		# Handle the double jump
		elif !is_on_floor() and (canCurrentlyDoubleJump() or coyotee_timer.time_left > 0):
			if coyotee_timer.time_left == 0:
				canDoubleJump = false
			velocity.y = JUMP_VELOCITY
	elif is_on_floor() and (jumpbuffer.time_left > 0):
		velocity.y = JUMP_VELOCITY
		
	#Allows for variable Jumphight
	elif Input.is_action_just_released("jump"):
		velocity.y *= 0.3
	#Enable double Jump when on the floor
	if(velocity.y == 0):
		canDoubleJump = true



#func calculateJump():
	

func handleMovement()-> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionHorizontal = Input.get_axis("left", "right")
	var directionVerical = Input.get_axis("down","up")
	
	if (directionHorizontal > 0):
		$Sprite2D.flip_h = false
	elif (directionHorizontal < 0):
		$Sprite2D.flip_h = true
	
  	
	if canMove:
		if directionHorizontal:
			velocity.x = directionHorizontal * SPEED
		elif !is_on_floor() and directionHorizontal:
			velocity.x = lerp(prevVelocity.x, velocity.x, 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/2)
			
		if directionVerical and canClimb:
			velocity.y = directionVerical * CLIMBING_SPEED
	
	
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
		velocity += get_gravity() * delta
		velocity.y = lerp(prevVelocity.y, velocity.y, 0.8)
		if was_on_floor:
			coyotee_timer.start(0.15)

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


func _on_enemy_got_stomped() -> void:
	velocity.y = JUMP_VELOCITY


func touching_ladder() -> void:
	canClimb = true
	


func leaving_ladder() -> void:
	canClimb = false
	


func _on_invincibilty_timer_timeout() -> void:
	canMove = true
	isInvincible = false
	$Sprite2D.material.set_shader_parameter("mix_color", 0)



func damage_taken(damage_value) -> void:
	if !isInvincible:
		$Sprite2D.material.set_shader_parameter("mix_color", 1)
		isInvincible = true
		canMove = false
		lifepoints -= 1
		if velocity.x >= 0:
			velocity.x = -120
		else:
			velocity.x = 120
		velocity.y = -230
		inv_timer.start(0.3)
	
