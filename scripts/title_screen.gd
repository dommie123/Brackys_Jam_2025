extends Control

signal start_game

func _on_start_button_pressed() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	start_game.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
