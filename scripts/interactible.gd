extends Area3D

class_name Interactible

signal item_interacted_with

func _on_area_entered(area: Area3D) -> void:
	item_interacted_with.emit()
