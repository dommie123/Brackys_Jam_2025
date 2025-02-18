extends Node3D

signal player_interact

@export var mainCamera: Camera3D

@export_category("Player Movement")
@export var speed: float
@export var jumpHeight: float
@export var gravity: float
@export var forwardVector: Vector3
@export var rightVector: Vector3
@export var sprintMultiplier: float

var isGrounded: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not mainCamera:
		forwardVector = Vector3.FORWARD
		rightVector = Vector3.RIGHT
		
	isGrounded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_physics()
	update_player_input()

# TODO have outside forces act on the player body
func update_player_physics() -> void:
	pass

# TODO read player inputs and translate them to actions
func update_player_input() -> void:
	update_player_movement()
	
	if Input.is_action_just_pressed("player_interact"):
		player_interact.emit()

# TODO check whether the player is touching the ground
func ground_check() -> bool: 
	return true

func update_player_movement() -> void:
	var player_forward_velocity = Input.get_axis("player_move_backward", "player_move_forward")
	var player_right_velocity = Input.get_axis("player_move_left", "player_move_right")
	
	player_forward_velocity *= speed * sprintMultiplier if Input.is_action_pressed("player_sprint") else 1
	player_right_velocity *= speed * sprintMultiplier if Input.is_action_pressed("player_sprint") else 1
	
	var movement: Vector3 = Vector3(
		position.x + player_right_velocity, 
		position.y,
		position.z + player_forward_velocity
	)
	
	position += movement
