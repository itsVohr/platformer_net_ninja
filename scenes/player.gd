extends CharacterBody2D

var direction_x := 0.0
var facing_right := true
@export var speed := 150
var can_shoot := true
var can_double_jump := true
var has_gun := false
var health := 100
var vulnerable: = true
var bullet_offset := 16
var is_dashing := false
var dash_on_cd := false
var dash_tween : Tween
var last_time_left := 0
var last_time_right := 0
signal shoot(pos: Vector2)
signal player_died


func _ready():
	$Timers/FireTimer.timeout.connect(_on_fire_timer_timeout)
	$Timers/CooldownTimer.timeout.connect(func(): can_shoot = true)
	$Timers/InvulnerabilityTimer.timeout.connect(func(): vulnerable = true)
	$Timers/DashCooldownTimer.timeout.connect(func(): dash_on_cd = false)
	$ShapeCast2D.enabled = false
	add_to_group("Player")

func _process(_delta):
	if not is_dashing:
		get_input()
		apply_gravity()
		get_animation()
		get_facing_direction()
		if is_on_floor():
			can_double_jump = true
		velocity.x = direction_x * speed
		move_and_slide()

func _physics_process(_delta):
	if is_dashing:
		if $ShapeCast2D.is_colliding():
			stop_dashing()

func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("left"):
		var left_dash_timer = Time.get_ticks_msec() - last_time_left
		last_time_left = Time.get_ticks_msec()
		if left_dash_timer < 500 and not is_dashing and not dash_on_cd:
			dash(-1)
	if Input.is_action_just_pressed("right"):
		var right_dash_timer = Time.get_ticks_msec() - last_time_right
		last_time_right = Time.get_ticks_msec()
		if right_dash_timer < 500 and not is_dashing and not dash_on_cd:
			dash(1)
	if Input.is_action_just_pressed("jump") and (is_on_floor() or can_double_jump):
		velocity.y = -300
		$Sounds/JumpSound.play()
		if not is_on_floor():
			can_double_jump = false
	if Input.is_action_just_pressed("shoot") and can_shoot and has_gun:
		shoot.emit(global_position, facing_right)
		can_shoot = false
		$Timers/CooldownTimer.start()
		$Timers/FireTimer.start()
		$Fire.get_child(facing_right).show()
		$Sounds/FireSound.play()

func dash(direction: int):
	$ShapeCast2D.enabled = true
	is_dashing = true
	dash_on_cd = true
	vulnerable = false
	$Timers/DashCooldownTimer.start()
	$ShapeCast2D.target_position = Vector2(direction, 0)
	var target_dash_position = position + Vector2(35*direction,0)
	dash_tween = get_tree().create_tween()
	dash_tween.tween_property(self, "position", target_dash_position, 0.1)
	await dash_tween.finished
	stop_dashing()

func stop_dashing():
	is_dashing = false
	vulnerable = true
	dash_tween.stop()
	$ShapeCast2D.enabled = false

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
		check_death()
		
func check_death():
	if health <= 0:
		player_died.emit()
