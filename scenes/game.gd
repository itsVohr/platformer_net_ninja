extends Node

var volume_has_changed := false

const CONFIG_FILE_PATH = "user://godot_test_config.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_data()
	$Music.finished.connect(_on_music_finished)
	$PauseMenu/CenterContainer/GridContainer/VolumeSlider.value_changed.connect(_on_volume_changed)
	$PauseMenu/CenterContainer/GridContainer/VolumeSlider.value = db_to_linear($Music.volume_db)
	$PauseMenu.visible = false
	GameState.game_status = "playing"

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Save the volume to a file before the game closes
		if volume_has_changed:
			_save_data(db_to_linear($Music.volume_db))
		get_tree().quit()	

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		$PauseMenu.visible = not $PauseMenu.visible

func _on_music_finished():
	$Music.play()

func _on_volume_changed(volume):
	$Music.volume_db = linear_to_db(volume)
	volume_has_changed = true

func _save_data(volume: float):
	var save_data := {"volume": volume}
	var save_file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
	if save_file != null:
		save_file.store_string(JSON.stringify(save_data))

func _load_data():
	var save_file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	if save_file != null:
		var save_data = JSON.parse_string(save_file.get_as_text())
		$Music.volume_db = linear_to_db(save_data["volume"])
	else:
		print("Couldn't load file")
