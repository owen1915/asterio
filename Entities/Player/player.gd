extends Entity

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("w"):
		dir.y = -1
	elif Input.is_action_pressed("s"):
		dir.y = 1
	
	if Input.is_action_pressed("a"):
		dir.x = -1
	elif Input.is_action_pressed("d"):
		dir.x = 1
	
	velocity = dir.normalized() * speed
	move_and_slide()
	_animation_process(dir)

func _animation_process(dir):
	if dir == Vector2.ZERO or velocity == Vector2.ZERO:
		sprite.play("idle_down")
		return
	
	if dir.x > 0:
		sprite.play("run_right")
		return
	elif dir.x < 0:
		sprite.play("run_left")
		return
	
	if dir.y > 0:
		sprite.play("run_down")
		return
	elif dir.y < 0:
		sprite.play("run_up")
		return
	
	
