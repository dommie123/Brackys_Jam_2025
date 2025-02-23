extends Control

signal end_game

@export_category("Audio Streams")
@export var hoverStream: AudioStream
@export var selectStream: AudioStream
@export var pauseStream: AudioStream

func _on_game_started() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	$StaminaBar.set_deferred("value", 100) # Player starts with full stamina


func _on_game_ended() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_PASS


func _on_player_update_stamina_bar(playerStamina: float) -> void:
	$StaminaBar.set_deferred("value", playerStamina)


func _on_level_update_hud_with_score(updatedScore: int) -> void:
	$ScoreCounter.set_deferred("text", "Score: %s" % updatedScore)


func toggle_pause_menu() -> void: 
	$PauseMenuPanel.set_deferred("visible", !$PauseMenuPanel.visible)
	$SFXPlayer.stream = pauseStream
	$SFXPlayer.play()


func _on_resume_button_pressed() -> void:
	$SFXPlayer.stream = pauseStream
	$SFXPlayer.play()
	
	get_tree().paused = false
	toggle_pause_menu()
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE if !get_tree().paused else MouseFilter.MOUSE_FILTER_PASS


func _on_main_menu_button_pressed() -> void:
	$SFXPlayer.stream = selectStream
	$SFXPlayer.play()
	
	get_tree().paused = false
	toggle_pause_menu()
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE if !get_tree().paused else MouseFilter.MOUSE_FILTER_PASS
	end_game.emit()


func _on_resume_button_focus_entered() -> void:
	play_hover_sfx()


func _on_resume_button_mouse_entered() -> void:
	play_hover_sfx()


func _on_main_menu_button_focus_entered() -> void:
	play_hover_sfx()


func _on_main_menu_button_mouse_entered() -> void:
	play_hover_sfx()


func play_hover_sfx() -> void: 
	$SFXPlayer.stream = hoverStream
	$SFXPlayer.play()
