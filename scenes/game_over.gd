extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.game_status == "lost":
		$VBoxContainer/GameOver.text = "GAME OVER!"
	if GameState.game_status == "won":
		$VBoxContainer/GameOver.text = "YOU WON!"
		$VBoxContainer/NiceTry.text = "god gamer"

func _input(_event):
	if Input.is_action_just_pressed("jump"):
		GameState.game_status = "playing"
		get_tree().change_scene_to_file("res://scenes/game.tscn")
