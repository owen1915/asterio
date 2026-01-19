extends Node2D

@onready var world: Node2D = $"../World"

var spawn_factor = 1
const SPAWN_SPEED = Vector2(5, 15)

var speed_factor = 2
const ASTEROID_SPEED = Vector2(25, 50)

var asteroids_alive = 0
var max_asteroids = 10

var spawn_range_min = Vector2(550, 100)
var spawn_range_max = Vector2(1400, 100)

var asteroid_scene = preload("res://nodes/entities/asteroids/asteroid.tscn")

func _ready() -> void:
	spawn_asteroid()
	start_spawn_timer()

func spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	
	asteroid.speed = randi_range(ASTEROID_SPEED.x, ASTEROID_SPEED.y) * speed_factor
	
	var spawn_x = randi_range(spawn_range_min.x, spawn_range_max.x)
	var spawn_y = randi_range(spawn_range_min.y, spawn_range_max.y)

	asteroid.global_position = Vector2(spawn_x, spawn_y)
	world.add_child(asteroid)
	asteroids_alive += 1

func start_spawn_timer() -> void:
	#await get_tree().create_timer(randi_range(SPAWN_SPEED.x, SPAWN_SPEED.y) * spawn_factor).timeout
	await get_tree().create_timer(0.1).timeout
	spawn_asteroid()
	start_spawn_timer()
