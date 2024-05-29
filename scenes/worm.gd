extends Enemy

var direction_x := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	damage = 30
	health = 2
	speed = 50
	$BorderArea.body_entered.connect(_on_obstacle_found)
	$CliffAreaRight.body_exited.connect(_on_obstacle_found)
	$CliffAreaLeft.body_exited.connect(_on_obstacle_found)

func _process(delta):
	position.x += speed * direction_x * delta

func _on_obstacle_found(_body):
	direction_x *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
