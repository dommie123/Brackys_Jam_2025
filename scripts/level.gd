extends Node3D

signal update_hud_with_score

@onready var currentLevelScore: int = 0

func _on_item_update_score_count(updatedScore: int) -> void:
	currentLevelScore += updatedScore
	update_hud_with_score.emit(currentLevelScore)
