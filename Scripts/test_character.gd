extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0


var hasDoubleJumpUpgrade:bool = false
var canDoubleJump = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle the double jump
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and canCurrentlyDoubleJump():
		canDoubleJump = !canDoubleJump
		velocity.y = JUMP_VELOCITY - 150

	if(velocity.y == 0):
		canDoubleJump = true


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if (direction > 0):
		$Sprite2D.flip_h = false
	elif (direction < 0):
		$Sprite2D.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()


func canCurrentlyDoubleJump() -> bool:
	if hasDoubleJumpUpgrade and canDoubleJump:
		return true
	else:
		return false
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	hasDoubleJumpUpgrade = !hasDoubleJumpUpgrade


func _on_enemy_got_stomped() -> void:
	velocity.y = JUMP_VELOCITY
