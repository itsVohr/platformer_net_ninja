extends Area2D

var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += sin(Time.get_ticks_msec() / 200.0) * 10 * delta


func _on_body_entered(body):
	if not picked_up:
		body.has_gun = true
		$PowerUpSound.play()
		$Sprite2D.hide()
		picked_up = true
		await $PowerUpSound.finished
		queue_free()
