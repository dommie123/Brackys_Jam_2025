extends CharacterBody3D

enum PlayerState {
	IDLE,
	WALK,
	RUN,
	INTERACT
}

enum PlayerAnimDirection {
	FORWARD,
	BACKWARD,
	LEFT,
	RIGHT
}

signal update_stamina_bar

@export var cameraPivot: Node3D

@export_category("Player Movement")
@export var speed: float
@export var jumpHeight: float
@export var gravity: float
@export var sprintMultiplier: float
@export var staminaDrainRate: float
@export var staminaRechargeRate: float

@export_category("Camera Rotation")
@export var camRotateSpeed: float
@export var pitchLimit: float
@export var mouseEnabled: bool
@export_range(0.0, 0.1) var mouseSensitivity: float

@onready var yVelocity: float = 0
@onready var currentStamina: float = 100.0
@onready var currentDirection: PlayerAnimDirection = PlayerAnimDirection.BACKWARD
@onready var currentState: PlayerState = PlayerState.IDLE

var forwardVector: Vector3
var rightVector: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InteractArea/CollisionShape3D.set_disabled(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_physics(delta)
	update_player_input(delta)
	update_player_animations()

# TODO have outside forces act on the player body
func update_player_physics(delta: float) -> void:
	pass
	

func update_player_input(delta: float) -> void:
	update_player_movement(delta)
	update_camera_movement(delta)
	
	if Input.is_action_just_pressed("player_interact"):
		$InteractArea/CollisionShape3D.set_disabled(false)
		$InteractTimer.start()
		currentState = PlayerState.INTERACT
		
		
func update_player_animations() -> void:
	currentDirection = get_current_direction()
	$AnimatedSprite3D.flip_h = currentDirection == PlayerAnimDirection.LEFT
	
	# Interact animation overrides all other animations
	if currentState == PlayerState.INTERACT and not "interact" in $AnimatedSprite3D.get_animation():
		if currentDirection == PlayerAnimDirection.BACKWARD:
			$AnimatedSprite3D.play("interact_back")
		elif currentDirection == PlayerAnimDirection.FORWARD:
			$AnimatedSprite3D.play("interact_front")
		else:
			$AnimatedSprite3D.play("interact_side")
	
	if currentState == PlayerState.INTERACT:
		return
	
	if velocity.length() > 0:
		currentState = PlayerState.RUN if Input.is_action_pressed("player_sprint") else PlayerState.WALK
	else:
		currentState = PlayerState.IDLE
	
	if currentDirection == PlayerAnimDirection.BACKWARD:
		if currentState == PlayerState.WALK:
			$AnimatedSprite3D.play(
				"walk_back",
				1.0
			)
		elif currentState == PlayerState.IDLE:
			$AnimatedSprite3D.set_animation("walk_back")
			$AnimatedSprite3D.set_frame(0)
		elif currentState == PlayerState.RUN:
			$AnimatedSprite3D.play(
				"walk_back",
				2.0
			)
	elif currentDirection == PlayerAnimDirection.FORWARD:
		if currentState == PlayerState.WALK:
			$AnimatedSprite3D.play(
				"walk_front",
				1.0
			)
		elif currentState == PlayerState.IDLE:
			$AnimatedSprite3D.set_animation("walk_front")
			$AnimatedSprite3D.set_frame(0)
		elif currentState == PlayerState.RUN:
			$AnimatedSprite3D.play(
				"walk_front",
				2.0
			)
	else:
		if currentState == PlayerState.IDLE:
			$AnimatedSprite3D.play("idle_side")
		elif currentState == PlayerState.WALK:
			$AnimatedSprite3D.play("walk_side")
		elif currentState == PlayerState.RUN:
			$AnimatedSprite3D.play("run_side")
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouseEnabled:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$CameraPivot.rotation.x -= event.relative.y * mouseSensitivity
		# Prevent the camera from rotating too far up or down.
		$CameraPivot.rotation.x = clampf($CameraPivot.rotation.x, -pitchLimit, pitchLimit)
		$CameraPivot.rotation.y += -event.relative.x * mouseSensitivity
		
		
func update_camera_movement(delta: float) -> void: 
	# Only execute the below code if the user doesn't want to enable
	# mouse controls for the camera.
	if mouseEnabled: 
		return
	else:
		var pivotYawRotationDirection = Input.get_axis(
			"camera_rotate_left", "camera_rotate_right"
		)
		var pivotPitchRotationDirection = Input.get_axis(
			"camera_rotate_down", "camera_rotate_up"
		)
		
		$CameraPivot.rotation.x += pivotPitchRotationDirection * (camRotateSpeed * delta)
		$CameraPivot.rotation.x = clampf(
			$CameraPivot.rotation.x, 
			-deg_to_rad(pitchLimit), 
			deg_to_rad(pitchLimit)
		)
		
		$CameraPivot.rotation.y += pivotYawRotationDirection * (camRotateSpeed * delta)
	
	
func update_player_movement(delta: float) -> void:
	# Adjust movement to be relative to cameraPivot
	var camera_basis = cameraPivot.global_transform.basis
	var forward = camera_basis.z.normalized()
	var right = camera_basis.x.normalized()
	var isSprinting = Input.is_action_pressed("player_sprint") and velocity.length() > 0
	var canSprint = currentStamina > 0.0
	
	if isSprinting and canSprint:
		currentStamina -= staminaDrainRate
	elif not isSprinting and currentStamina < 100:
		currentStamina += staminaRechargeRate
	
	update_stamina_bar.emit(currentStamina)
	
	if not is_on_floor():
		yVelocity -= gravity * delta
	elif Input.is_action_just_pressed("player_jump"):
		yVelocity = jumpHeight
		
	var input_direction = Input.get_axis("player_move_left", "player_move_right") * right + Input.get_axis("player_move_forward", "player_move_backward") * forward
	input_direction = input_direction.normalized()
	
	var speed_multiplier = sprintMultiplier if isSprinting and canSprint else 1
	var total_speed = speed * speed_multiplier
	
	if is_on_floor() and yVelocity < 0:
		yVelocity = 0
		
	velocity = input_direction * total_speed
	velocity.y = yVelocity

	move_and_slide()


func update_forward_and_right_vectors() -> void:
	var newForwardVector: Vector3
	var newRightVector: Vector3
	
	if not cameraPivot:
		newForwardVector = Vector3.FORWARD
		newRightVector = Vector3.RIGHT
	else:
		newForwardVector = Vector3(-cameraPivot.basis.z.x, 0, -cameraPivot.basis.z.z)
		newRightVector = cameraPivot.basis.x
		
	forwardVector = newForwardVector
	rightVector = newRightVector
	
func get_current_direction() -> PlayerAnimDirection:
	var camera_basis = cameraPivot.global_transform.basis
	var forward = camera_basis.z.normalized()
	var right = camera_basis.x.normalized()
	
	var forwardThreshold = 0.5
	var rightThreshold = 0.5
	
	var dotProductForward = forward.dot(velocity)
	var dotProductRight = right.dot(velocity)
	
	if dotProductForward > forwardThreshold:
		return PlayerAnimDirection.FORWARD
	elif dotProductRight > rightThreshold:
		return PlayerAnimDirection.RIGHT
	elif dotProductForward < -forwardThreshold:
		return PlayerAnimDirection.BACKWARD
	elif dotProductRight < -rightThreshold:
		return PlayerAnimDirection.LEFT
	else:
		return currentDirection

func _on_interact_timer_timeout() -> void:
	$InteractArea/CollisionShape3D.set_disabled(true)
	currentState = PlayerState.IDLE
