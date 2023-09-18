extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		velocity += Vector2.UP
	if Input.is_action_pressed("move_down"):
		velocity += Vector2.DOWN
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = velocity.y > 0
			$AnimatedSprite2D.flip_h = false
		
		$AnimatedSprite2D.play()
		
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	else:
		$AnimatedSprite2D.stop()


func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
