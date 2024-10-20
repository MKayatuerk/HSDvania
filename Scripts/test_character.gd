extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -200.0
const CLIMBING_SPEED = -100

var dropTime = 0.2

# Checks if the Doublejump upgrade has been collected
var hasDoubleJumpUpgrade:bool = false

# Checks if the character can currently doubleJump
# Only effective when hasDoubleJumpUpgrade = true 
var canDoubleJump:bool = true

# Checks if the character can currently climb
var canClimb:bool = false


var canDropDown:bool = false 

var direction: float = 0

@onready var animationPlayer = $AnimationPlayer
@onready var drop_timer: Timer = $DropTimer


#Main loop of the character
func _physics_process(delta: float) -> void:
	#print("can climb: " + str(canClimb) + " is on floor: " + str(is_on_floor())+ " can double Jump: " + str(canDoubleJump))
	handleJump(delta)
	handleMovement()



# Function that handles the Jump functionality

func handleJump(delta: float)-> void:
	# Add the gravity
	if  not is_on_floor():
		velocity += get_gravity() * delta
		

	# Check for the diffrent possible cases when pressing jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		
		#Handle dropping down through passable objects
		if Input.is_action_pressed("down"):
			dropDown() 

		else: velocity.y = JUMP_VELOCITY
		
	# Handle the double jump
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and canCurrentlyDoubleJump():
		canDoubleJump = !canDoubleJump
		velocity.y = JUMP_VELOCITY - 150
	#Enable double Jump when on the floor
	if(velocity.y == 0):
		canDoubleJump = true


func handleMovement()-> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	
	if (direction > 0):
		$Sprite2D.flip_h = false
	elif (direction < 0):
		$Sprite2D.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_animations(direction)
	climb()


# climbing function based on the basic movement controller
func climb() -> void:
	var direction := Input.get_axis("down","up")
	
	if direction and canClimb:
		velocity.y = direction * CLIMBING_SPEED
	
	move_and_slide()
	
	
func dropDown() -> void:
	drop_timer.start(dropTime)
	set_collision_mask_value(1,false)


#Function that returns true if all conditions are met to allow the character
#To double jump
func canCurrentlyDoubleJump() -> bool:
	if hasDoubleJumpUpgrade and canDoubleJump:
		return true
	else:
		return false

# Function that fires the walking animation of the player upon walking
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Walk")
	else:
		pass


##---------------------SIGNALS------------------------------------------------
func _on_area_2d_body_entered(body: Node2D) -> void:
	hasDoubleJumpUpgrade = !hasDoubleJumpUpgrade


func _on_enemy_got_stomped() -> void:
	velocity.y = JUMP_VELOCITY


func _on_ladder_body_entered(body: Node2D) -> void:
	print("hey")
	canClimb = true
	


func _on_ladder_body_exited(body: Node2D) -> void:
	canClimb = false
	


func _on_drop_timer_timeout() -> void:
	print("test")
	set_collision_mask_value(1,true)


func _on_passable_object_body_entered(body: Node2D) -> void:
	canDropDown = true
