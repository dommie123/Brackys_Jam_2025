extends RigidBody3D

class_name MovingPlatform

enum State {
	MOVING,
	IDLE
}

enum Direction {
	TO_TARGET,
	TO_SOURCE
}

@export var platformSpeed: float
@export_range(0.0, 10.0) var distanceThreshold: float
@export var sourceDestination: Vector3
@export var targetDestination: Vector3

@onready var currentState: State = State.MOVING
@onready var currentDirection: Direction = Direction.TO_TARGET

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentState == State.IDLE:
		return
	
	var toPosition = sourceDestination if currentDirection == Direction.TO_SOURCE else targetDestination
	var fromPosition = targetDestination if currentDirection == Direction.TO_SOURCE else sourceDestination
	
	if position.distance_to(toPosition) <= distanceThreshold:
		currentState = State.IDLE
		currentDirection = Direction.TO_SOURCE if currentDirection == Direction.TO_TARGET else Direction.TO_TARGET
		$IdleTimer.start()
	else:
		position += position.direction_to(toPosition) * platformSpeed * delta
	
	
func _on_idle_timer_timeout() -> void:
	currentState = State.MOVING
