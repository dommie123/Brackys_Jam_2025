extends Node3D

signal game_started
signal game_ended

@export_category("Background Audio")
@export var titleTheme: AudioStream
@export var mainTheme: AudioStream

@onready var gameStarted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/CameraPivot/SpringArm3D/MainCamera.clear_current()
	
	$Player.set_deferred("visible", false)
	$HUD.set_deferred("visible", false)
	$TitleScreen.set_deferred("visible", true)
	
	$OrbitalCamera.make_current()
	
	$BGMPlayer.stream = titleTheme
	$BGMPlayer.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !gameStarted:
		pass
	else:
		if Input.is_action_just_pressed("player_pause"):
			$HUD.toggle_pause_menu()
			get_tree().paused = !get_tree().paused
			$BGMPlayer.set_volume_db(-20 if get_tree().paused else 0) 
	


func _on_title_screen_start_game() -> void:
	gameStarted = true
	$OrbitalCamera.clear_current()
	
	$Player.set_deferred("visible", true)
	$HUD.set_deferred("visible", true)
	$TitleScreen.set_deferred("visible", false)
	
	$Player/CameraPivot/SpringArm3D/MainCamera.make_current()
	
	$BGMPlayer.stream = mainTheme
	$BGMPlayer.play()
	
	game_started.emit()


func _on_hud_end_game() -> void:
	gameStarted = false
	$Player/CameraPivot/SpringArm3D/MainCamera.clear_current()
	
	$Player.set_deferred("visible", false)
	$HUD.set_deferred("visible", false)
	$TitleScreen.set_deferred("visible", true)
	
	$OrbitalCamera.make_current()

	$BGMPlayer.set_volume_db(0) 
	$BGMPlayer.stream = titleTheme
	$BGMPlayer.play()
	
	game_ended.emit()
