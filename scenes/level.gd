extends Node2D

const bullet_scene := preload("res://scenes/bullet.tscn")

@onready var game_over_scene = preload("res://scenes/game_over.tscn")

func _ready():
	$Player.player_died.connect(_on_player_died)

func _on_player_shoot(pos: Vector2, facing_right: bool):
	var bullet  = bullet_scene.instantiate()
	var direction = 1 if facing_right else -1
	$Player.bullet_offset = direction
	bullet.position = pos + Vector2(direction * 8, 2)
	bullet.direction = direction
	$Bullets.add_child(bullet)

func _on_player_died():
	call_deferred("game_over")
	
func game_over():
	get_tree().change_scene_to_packed(game_over_scene)
