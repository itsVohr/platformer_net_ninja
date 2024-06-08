extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.finished.connect(_on_music_finished)
	GameState.game_status = "playing"
	
func _on_music_finished():
	$Music.play()

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		$PauseMenu.visible = not $PauseMenu.visible
