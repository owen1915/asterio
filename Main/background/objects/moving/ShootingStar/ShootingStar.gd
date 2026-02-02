extends AnimatedSprite2D

var speed : int
var dir = Vector2(-0.5, 0.5)

func _ready() -> void:
	speed = randi_range(25, 200)

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta
	if global_position.y > 540 or global_position.x < -100:
		queue_free()
