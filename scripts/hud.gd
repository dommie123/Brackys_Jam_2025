extends Control

signal end_game

func _on_game_started() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	$StaminaBar.set_deferred("value", 100) # Player starts with full stamina


func _on_game_ended() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_PASS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_update_stamina_bar(playerStamina: float) -> void:
	$StaminaBar.set_deferred("value", playerStamina)


func _on_level_update_hud_with_score(updatedScore: int) -> void:
	$ScoreCounter.set_deferred("text", "Score: %s" % updatedScore)

func toggle_pause_menu() -> void: 
	$PauseMenuPanel.set_deferred("visible", !$PauseMenuPanel.visible)

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	toggle_pause_menu()
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE if !get_tree().paused else MouseFilter.MOUSE_FILTER_PASS


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	toggle_pause_menu()
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE if !get_tree().paused else MouseFilter.MOUSE_FILTER_PASS
	end_game.emit()
