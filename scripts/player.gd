extends CharacterBody3D

signal player_interact

@export var mainCamera: Camera3D

@export_category("Player Movement")
@export var speed: float
@export var jumpHeight: float
@export var gravity: float
@export var sprintMultiplier: float

var forwardVector: Vector3
var rightVector: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_physics(delta)
	update_player_input(delta)

# TODO have outside forces act on the player body
func update_player_physics(delta: float) -> void:
	pass
	

# TODO read player inputs and translate them to actions
func update_player_input(delta: float) -> void:
	update_player_movement(delta)
	
	if Input.is_action_just_pressed("player_interact"):
		player_interact.emit()
		

func update_player_movement(delta: float) -> void:
	update_forward_and_right_vectors()
	
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		print("I have jumped!")
		velocity.y = -jumpHeight
	elif !is_on_floor():
		velocity.y -= gravity * delta
	
	var inputDirection: Vector3 = Vector3(
		Input.get_axis("player_move_left", "player_move_right"),
		velocity.y,
		Input.get_axis("player_move_forward", "player_move_backward"),
	).normalized()
	
	var speedMultiplier: float = sprintMultiplier if Input.is_action_pressed("player_sprint") else 1
	var totalSpeed: float = inputDirection.length() * (speed * speedMultiplier) * delta
	
	velocity = inputDirection * totalSpeed
	
	move_and_slide()

func update_forward_and_right_vectors() -> void:
	var newForwardVector: Vector3
	var newRightVector: Vector3
	
	if not mainCamera:
		newForwardVector = Vector3.FORWARD
		newRightVector = Vector3.RIGHT
	else:
		newForwardVector = Vector3(-mainCamera.basis.z.x, 0, -mainCamera.basis.z.z)
		newRightVector = mainCamera.basis.x
		
	forwardVector = newForwardVector
	rightVector = newRightVector
	
