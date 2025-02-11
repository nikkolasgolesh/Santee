extends CharacterBody2D

@onready var AS: AnimatedSprite2D = $AnimatedSprite2D
@onready var FallTimer: Timer = $Timer

const SPEED = 500.0
const ACCELERATION := 200.0
const DECELERATION := 200.0
const GRAVITY := 400.0

var desiredDirection : Vector2 = Vector2(0.0, 0.0)
var bIsFalling := false

func _ready() -> void:
	FallTimer.start()
	AS.play("idle")

func _process(delta: float) -> void:
	PlayerInputProcess()
	PlayerDirectionUpdate(delta)
	AnimationControllerUpdate(delta)
	
	print("Desired(%s) Velocity(%s)", str(desiredDirection), str(velocity))

# this could be on an input node and shouldn't be necessary to the character
func PlayerInputProcess() -> void:
	var inputHorizontalAxisValue := Input.get_axis("MoveLeft", "MoveRight")
	var inputVerticalAxisValue := Input.get_axis("MoveUp", "MoveDown")
	SetDesiredDirection(inputHorizontalAxisValue, inputVerticalAxisValue)
	if abs(inputHorizontalAxisValue) > 0 or abs(inputVerticalAxisValue) > 0:
		ResetFallTimer()

func ResetFallTimer() -> void:
	bIsFalling = false;
	FallTimer.start()

func _physics_process(delta: float) -> void:
	ProcessMovement(delta)
	move_and_slide()
	ResolveMovement()

# do we want to move things like this to a movement node to control how characters are moved 
func SetDesiredDirection(x: float, y: float) -> void:
	desiredDirection.x = x;
	desiredDirection.y = y;

func ProcessMovement(physicsDelta: float) -> void:
	
	if desiredDirection.x:
		velocity.x = move_toward(velocity.x, desiredDirection.x * SPEED, ACCELERATION * physicsDelta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * physicsDelta)

	if desiredDirection.y:
		velocity.y = move_toward(velocity.y, desiredDirection.y * SPEED, ACCELERATION * physicsDelta)
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION * physicsDelta)

	if bIsFalling:
		velocity.y += GRAVITY * physicsDelta

func ResolveMovement() -> void:
	if is_on_wall():
		var wallNormal = get_wall_normal()
		if  wallNormal.x > 0: # we are colliding on the left
			if desiredDirection.x > 0: # we are moving right
				velocity.x = 0
			else: # we are moving left
				velocity.x = 0
		elif wallNormal.x < 0: # we are colliding on the right
			if desiredDirection.x > 0: # we are moving right
				velocity.x = 0
			else: # we are moving left
				velocity.x = 0

		if wallNormal.y > 0:
			if desiredDirection.y > 0:
				velocity.y = 0
			else:
				velocity.y = 0
		elif wallNormal.y < 0:
			if desiredDirection.y < 0:
				velocity.y = 0
			else:
				velocity.y = 0

# should this be on an animation controller node
func AnimationControllerUpdate(delta: float) -> void:
	if velocity.length_squared() > 0.0:
		AS.play("fly")
	else:
		AS.play("idle")

func PlayerDirectionUpdate(delta : float) -> void:
	if desiredDirection.x < 0:
		AS.flip_h = true
	elif desiredDirection.x > 0:
		AS.flip_h = false


func _on_timer_timeout() -> void:
	bIsFalling = true
