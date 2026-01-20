class_name Asteroid extends Entity

var asteroid_manager = null
var damage = 20
var og_speed = 0.0
var rotation_speed = 0.0

func _ready() -> void:
	asteroid_manager = get_tree().get_first_node_in_group("asteroid_manager")
	add_to_group("Asteroid")
	rotation_speed = randf_range(0.01, 0.05)
	super()

func _physics_process(delta: float) -> void:
	var dir = Vector2(0, 1)
	velocity = dir.normalized() * speed 
	rotation += rotation_speed
	
	if global_position.y > 1080:
		take_damage(10000)
	
	super(delta)

func take_damage(damage) -> void:
	health -= damage
	if health <= 0:
		asteroid_manager.asteroids_alive -= 1
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("breakable") and body.not_ghost:
		body.take_damage(damage)
		take_damage(10000)
