extends Node2D

const bullet_scene := preload("res://scenes/bullet.tscn")

@onready var game_over_scene = preload("res://scenes/game_over.tscn")


func _ready():
	$Player.player_died.connect(_on_player_died)
	GameState.enemies_remanining = get_tree().get_nodes_in_group("enemies").size()
	update_enemy_counter()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.enemy_died.connect(_on_enemy_died)

func _on_player_shoot(pos: Vector2, facing_right: bool):
	var bullet  = bullet_scene.instantiate()
	var direction = 1 if facing_right else -1
	$Player.bullet_offset = direction
	bullet.position = pos + Vector2(direction * 8, 2)
	bullet.direction = direction
	$Bullets.add_child(bullet)

func _on_player_died():
	GameState.game_status = "lost"
	call_deferred("game_over")
	
func _on_enemy_died():
	GameState.enemies_remanining -= 1
	update_enemy_counter()
	if GameState.enemies_remanining == 0:
		GameState.game_status = "won"
		call_deferred("game_over")
	
func game_over():
	get_tree().change_scene_to_packed(game_over_scene)

func update_enemy_counter():
	$UI/MarginContainer/EnemyCounter.text = "ENEMIES REMAINING: " + str(GameState.enemies_remanining)
