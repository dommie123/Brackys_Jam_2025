extends Interactible

class_name PuzzleArea

signal puzzle_started
signal puzzle_completed

@export var puzzle_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_item_interacted_with() -> void:
	# TODO begin puzzle microgame
	puzzle_started.emit(puzzle_id)
	#puzzle_completed.emit(puzzle_id)
