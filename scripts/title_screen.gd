extends Control

signal start_game

@export_category("Audio Streams")
@export var hoverStream: AudioStream
@export var selectStream: AudioStream

func _on_start_button_pressed() -> void:
	$SFXPlayer.set_deferred("stream", selectStream)
	$SFXPlayer.play()
	
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	start_game.emit()


func _on_exit_button_pressed() -> void:
	$SFXPlayer.set_deferred("stream", selectStream)
	$SFXPlayer.play()
	
	get_tree().quit()


func _on_exit_button_focus_entered() -> void:
	play_hover_sfx()


func _on_start_button_focus_entered() -> void:
	play_hover_sfx()


func _on_start_button_mouse_entered() -> void:
	play_hover_sfx()


func _on_exit_button_mouse_entered() -> void:
	play_hover_sfx()
	
	
func play_hover_sfx() -> void:
	$SFXPlayer.stream = hoverStream
	$SFXPlayer.play()
