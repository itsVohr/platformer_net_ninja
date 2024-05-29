class_name Enemy
extends Area2D

var damage := 0
var health := 0
var speed := 0

signal enemy_died

func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	add_to_group("enemies")

func _on_body_entered(body):
	if 'get_damage' in body:
		body.get_damage(damage)

func check_health():
	if health <= 0:
		enemy_died.emit()
		await $DamageSound.finished
		queue_free()

func _on_area_entered(bullet):
	health -= 1
	bullet.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	$DamageSound.play()
	check_health()
