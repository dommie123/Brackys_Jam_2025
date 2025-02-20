extends CharacterBody3D

signal player_interact

@export var cameraPivot: Node3D

@export_category("Player Movement")
@export var speed: float
@export var jumpHeight: float
@export var gravity: float
@export var sprintMultiplier: float

@export_category("Camera Rotation")
@export var camRotateSpeed: float
@export var pitchLimit: float

var forwardVector: Vector3
var rightVector: Vector3
var yVelocity: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yVelocity = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_physics(delta)
	update_player_input(delta)

# TODO have outside forces act on the player body
func update_player_physics(delta: float) -> void:
	pass
	

func update_player_input(delta: float) -> void:
	update_player_movement(delta)
	update_camera_movement(delta)
	
	if Input.is_action_just_pressed("player_interact"):
		player_interact.emit()
		

func update_camera_movement(delta: float) -> void: 
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
	
	if not is_on_floor():
		yVelocity -= gravity * delta
	elif Input.is_action_just_pressed("player_jump"):
		yVelocity = jumpHeight
		
	var input_direction = Input.get_axis("player_move_left", "player_move_right") * right + Input.get_axis("player_move_forward", "player_move_backward") * forward
	input_direction = input_direction.normalized()
	
	var speed_multiplier = sprintMultiplier if Input.is_action_pressed("player_sprint") else 1
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
	
