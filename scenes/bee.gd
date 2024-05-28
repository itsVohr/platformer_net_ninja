extends Area2D

var health := 3

@export var marker1: Marker2D
@export var marker2: Marker2D
var speed := 25
@onready var target = marker2
var forward :=  true
@onready var player := get_tree().get_first_node_in_group("Player")
var notice_radius := 75
var damage := 20

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	position = marker1.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_health()
	get_target()
	position += (target.position - position).normalized() * speed * delta
	
func get_target():
	if position.distance_to(player.position) < notice_radius:
		target = player
	else:
		if forward and position.distance_to(marker2.position) < 10 or\
			not forward and position.distance_to(marker1.position) < 10:
			forward = not forward
		if forward:
			target = marker2
		else:
			target = marker1
	if target.position.x < position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
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
