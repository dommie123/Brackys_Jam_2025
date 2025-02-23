extends MovingPlatform

class_name PuzzlePlatform

enum PuzzleState {
	INCOMPLETE,
	COMPLETE
}

@export var puzzle_id: int

@onready var currentPuzzleState: PuzzleState = PuzzleState.INCOMPLETE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = sourceDestination
	
	currentDirection = Direction.TO_TARGET
	currentState = State.IDLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentState == State.MOVING and currentPuzzleState == PuzzleState.COMPLETE:
		if position.distance_to(targetDestination) <= distanceThreshold:
			currentState = State.IDLE
		else:
			position += position.direction_to(targetDestination) * platformSpeed * delta


func on_puzzle_complete(id: int) -> void:
	if id == puzzle_id:
		currentPuzzleState = PuzzleState.COMPLETE
		currentState = State.MOVING
