extends CharacterBody2D

var direction_x := 0.0
var facing_right = true
@export var speed = 150
var can_shoot := true
var can_double_jump := true
var has_gun := false
var health := 100
var vulnerable: = true

signal shoot(pos: Vector2)

func _ready():
	$Timers/FireTimer.timeout.connect(_on_fire_timer_timeout)
	$Timers/CooldownTimer.timeout.connect(func(): can_shoot = true)
	$Timers/InvulnerabilityTimer.timeout.connect(func(): vulnerable = true)
	add_to_group("Player")

func _process(_delta):
	get_input()
	apply_gravity()
	get_animation()
	get_facing_direction()
	if is_on_floor():
		can_double_jump = true
	
	velocity.x = direction_x * speed
	move_and_slide()
	check_death()

func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump") and (is_on_floor() or can_double_jump):
		velocity.y = -300
		$Sounds/JumpSound.play()
		if not is_on_floor():
			can_double_jump = false
			$Timers/JumpCooldown
	if Input.is_action_just_pressed("shoot") and can_shoot and has_gun:
		shoot.emit(global_position, facing_right)
		can_shoot = false
		$Timers/CooldownTimer.start()
		$Timers/FireTimer.start()
		$Fire.get_child(facing_right).show()
		$Sounds/FireSound.play()
		
func apply_gravity():
	velocity.y += 20

func _on_fire_timer_timeout():
	for child in $Fire.get_children():
		child.hide()

func get_facing_direction():
	if direction_x != 0:
		facing_right = direction_x >= 0

func get_animation():
	var animation = 'idle'
	if not is_on_floor():
		animation = 'jump'
	elif direction_x != 0:
		animation = 'walk'
	if has_gun:
		animation += '_gun'
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.flip_h = not facing_right
	
func get_damage(amount: int):
	if vulnerable:
		health -= amount
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
		vulnerable = false
		$Timers/InvulnerabilityTimer.start()
		$Sounds/DamageSound.play()
		
func check_death():
	if health <= 0:
		get_tree().quit()
