extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0


# Checks if the Doublejump upgrade has been collected
var hasDoubleJumpUpgrade:bool = false

# Checks if the character can currently doubleJump
# Only effective when hasDoubleJumpUpgrade = true 
var canDoubleJump:bool = true

# Checks if the character can currently climb
var canClimb:bool = false


var direction: float = 0

@onready var animationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	print("can climb: " + str(canClimb) + " is on floor: " + str(is_on_floor())+ " can double Jump: " + str(canDoubleJump))
	handleJump(delta)
	handleMovement()
	move_and_slide()




# Function that handles the Jump functionality

func handleJump(delta: float)-> void:
	# Add the gravity.r
	if  not (is_on_floor() and canClimb):
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
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
	
	climb()


# climbing function based on the basic movement controller
func climb() -> void:
	var direction := Input.get_axis("down","up")
	
	if direction and canClimb:
		velocity.y = direction * CLIMBING_SPEED
	
	move_and_slide()
	
	update_animations(direction)


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


func _on_ladder_body_entered(body: Node2D) -> void:
	canClimb = true
	


func _on_ladder_body_exited(body: Node2D) -> void:
	canClimb = false
	
func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Walk")
	else:
		pass
