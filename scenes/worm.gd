extends Area2D

var health := 2
var direction_x := 1
@export var speed := 50
var damage := 30

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	$BorderArea.body_entered.connect(_on_border_area_entered)
	$CliffAreaRight.body_exited.connect(_on_cliff_area_exited)
	$CliffAreaLeft.body_exited.connect(_on_cliff_area_exited)

func _process(delta):
	check_health()
	position.x += speed * direction_x * delta
	
func check_health():
	if health <= 0:
		await $DamageSound.finished
		queue_free()

func _on_area_entered(bullet):
	health -= 1
	bullet.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	$DamageSound.play()
	
func _on_body_entered(body):
	if 'get_damage' in body:
		body.get_damage(damage)
		
func _on_border_area_entered(_body):
	direction_x *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func _on_cliff_area_exited(_body):
	direction_x *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
