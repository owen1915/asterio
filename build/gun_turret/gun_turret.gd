extends Building

@onready var head: Sprite2D = $head
var damage = 20
var shooting_factor = 1
var can_shoot = true

var focused_asteroid = Asteroid
var asteroid_queue : Array = []

@onready var bullet_scene = preload("res://build/gun_turret/bullet/bullet.tscn")

func _ready() -> void:
	add_to_group("breakable")
	super()

func _process(delta: float) -> void:
	if len(asteroid_queue) > 0 and not_ghost:
		head.look_at(asteroid_queue[0].global_position)
		head.rotation += PI / 2
		if can_shoot:
			shoot_bullet()
			reset_shoot()
		 
func reset_shoot() -> void:
	can_shoot = false
	await get_tree().create_timer(1 * shooting_factor).timeout
	can_shoot = true

func shoot_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = head.global_position
	bullet.target = asteroid_queue[0]
	bullet.damage = damage
	get_tree().root.add_child(bullet)

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		asteroid_queue.push_back(body)


func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		asteroid_queue.erase(body)
