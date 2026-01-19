extends Building

@onready var head: Sprite2D = $head
var damage = 20
var shooting_factor = 1
var can_shoot = true

var focused_asteroid = Asteroid
var asteroid_queue : Array = []

func _process(delta: float) -> void:
	if len(asteroid_queue) > 0:
		head.look_at(asteroid_queue[0].global_position)
		head.rotation += PI / 2
		if can_shoot:
			shoot_bullet()
			reset_shoot()
		 
func reset_shoot() -> void:
	can_shoot = false
	await get_tree().create_timer(1 * shooting_factor)
	can_shoot = true

func shoot_bullet() -> void:
	if asteroid_queue[0].health - damage <= 0:
		asteroid_queue[0].take_damage(damage)
		asteroid_queue.remove_at(0)
	else:
		asteroid_queue[0].take_damage(damage)

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		asteroid_queue.push_back(body)


func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		asteroid_queue.erase(body)
