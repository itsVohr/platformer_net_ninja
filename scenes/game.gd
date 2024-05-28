extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.finished.connect(_on_music_finished)
	
func _on_music_finished():
	print("LOOP TIME")
	$Music.play()
