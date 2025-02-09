extends CharacterBody2D

@onready var AS: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION := 50.0
const DECELERATION := 100.0

func _ready() -> void:
	AS.play("idle")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal := Input.get_axis("MoveLeft", "MoveRight")
	if horizontal:
		velocity.x = move_toward(velocity.x, horizontal * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		
	var vertical := Input.get_axis("MoveUp", "MoveDown")
	if vertical:
		velocity.y = move_toward(velocity.y, vertical * SPEED, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION * delta)

	move_and_slide()
