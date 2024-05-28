extends Node2D

const bullet_scene := preload("res://scenes/bullet.tscn")

func _on_player_shoot(pos: Vector2, facing_right: bool):
	var bullet  = bullet_scene.instantiate()
	var direction = 1 if facing_right else -1
	var bullet_offset = Vector2(14 * direction,0)
	bullet.position = pos + bullet_offset
	bullet.direction = direction
	$Bullets.add_child(bullet)
