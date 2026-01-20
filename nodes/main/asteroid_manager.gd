extends Node2D

@onready var world: Node2D = $"../World"
@onready var speed_manager: Node2D = $"../SpeedManager"

var spawn_factor = 1.0
const SPAWN_SPEED = Vector2(1, 1)

var speed_factor = 1.0
const ASTEROID_SPEED = Vector2(25, 50)

var asteroids_alive = 0
var max_asteroids = 10

var spawn_range_min = Vector2(550, 100)
var spawn_range_max = Vector2(1400, 100)

var asteroid_scene = preload("res://nodes/entities/asteroids/asteroid.tscn")

func update_asteroid_stats() -> void:
	speed_factor = (speed_manager.speed / 10) + 1.0 # every 100m/s adds 0.1 to factor
	spawn_factor = max(0.5, 1.0 - (speed_manager.speed / 50))
	for child in world.get_children():
		if child is Asteroid:
			child.speed = child.og_speed * speed_factor

func _ready() -> void:
	spawn_asteroid()
	start_spawn_timer()

func spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	
	asteroid.og_speed = randi_range(ASTEROID_SPEED.x, ASTEROID_SPEED.y)
	asteroid.speed = asteroid.og_speed * speed_factor
	
	var spawn_x = randi_range(spawn_range_min.x, spawn_range_max.x)
	var spawn_y = randi_range(spawn_range_min.y, spawn_range_max.y)

	asteroid.global_position = Vector2(spawn_x, spawn_y)
	world.add_child(asteroid)
	asteroids_alive += 1

func start_spawn_timer() -> void:
	await get_tree().create_timer(randi_range(SPAWN_SPEED.x, SPAWN_SPEED.y) * spawn_factor).timeout
	spawn_asteroid()
	start_spawn_timer()
