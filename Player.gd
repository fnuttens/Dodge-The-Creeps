extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _process(delta):
	var velocity = get_direction_from_input()

	if velocity.length() > 0:
		$AnimatedSprite.play()
		update_position(velocity, delta)
	else:
		$AnimatedSprite.stop()

	update_animation(velocity)

func get_direction_from_input():
	var velocity = Vector2() # The player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	return velocity

func update_position(velocity, delta):
	# Avoid faster diagonals
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	# Keep player from going out of screen
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func update_animation(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	$CollisionShape2D.call_deferred("set_disabled", true)