extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	$StaminaBar.set_deferred("value", 100) # Player starts with full stamina


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_update_stamina_bar(playerStamina: float) -> void:
	$StaminaBar.set_deferred("value", playerStamina)


func _on_level_update_hud_with_score(updatedScore: int) -> void:
	$ScoreCounter.set_deferred("text", "Score: %s" % updatedScore)
