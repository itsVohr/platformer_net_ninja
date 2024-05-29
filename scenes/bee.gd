extends Enemy


@export var marker1: Marker2D
@export var marker2: Marker2D
@onready var target = marker2
var forward :=  true
@onready var player := get_tree().get_first_node_in_group("Player")
var notice_radius := 75

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	health = 3
	speed = 25
	damage = 20
	position = marker1.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
