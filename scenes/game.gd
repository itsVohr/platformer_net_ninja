extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.finished.connect(_on_music_finished)
	$PauseMenu/CenterContainer/GridContainer/VolumeSlider.value_changed.connect(_on_volume_changed)
	$PauseMenu/CenterContainer/GridContainer/VolumeSlider.value = db_to_linear($Music.volume_db)
	$PauseMenu.visible = false
	GameState.game_status = "playing"
	
func _on_music_finished():
	$Music.play()

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		$PauseMenu.visible = not $PauseMenu.visible

func _on_volume_changed(volume):
	$Music.volume_db = linear_to_db(volume)
