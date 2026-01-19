extends Entity

var asteroid_manager = null
var damage = 20

func _ready() -> void:
	asteroid_manager = get_tree().get_first_node_in_group("asteroid_manager")

func _physics_process(delta: float) -> void:
	var dir = Vector2(0, 1)
	velocity = dir.normalized() * speed 
	
	if global_position.y > 1080:
		kill()
	
	super(delta)

func kill() -> void:
	asteroid_manager.asteroids_alive -= 1
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("breakable") and body.not_ghost:
		body.take_damage(damage)
		kill()
		print(body.name)
