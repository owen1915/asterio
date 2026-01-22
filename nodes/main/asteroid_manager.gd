extends Node2D

@onready var world: Node2D = $"../World"
@onready var speed_manager: Node2D = $"../SpeedManager"

var spawn_factor = 1
const SPAWN_SPEED = Vector2(1, 1)

var speed_factor = 1.0
const ASTEROID_SPEED = Vector2(25, 50)

var asteroids_alive = 0
var max_asteroids = 10

var spawn_range_min = Vector2(550, 100)
var spawn_range_max = Vector2(1400, 100)

var asteroid_scene = preload("res://nodes/entities/asteroids/asteroid.tscn")

var easy = {
	"texture" : preload("res://nodes/entities/asteroids/sprites/asteroid_1-export.png"),
	"health" : 20
}

var medium = {
	"texture" : preload("res://nodes/entities/asteroids/sprites/asteroid_2.png"),
	"health" : 40
}

var hard = {
	"texture" : preload("res://nodes/entities/asteroids/sprites/hard.png"),
	"health" : 60
}

func _ready() -> void:
	start_spawn_timer()

func update_asteroid_stats() -> void:
	speed_factor = 1.0 + pow(speed_manager.speed, 0.6) * 0.18
	spawn_factor = clamp(1.0 / (1.0 + pow(speed_manager.speed, 0.9) * 0.08), 0.25, 1.0)
	for child in world.get_children():
		if child is Asteroid:
			child.speed = child.og_speed * speed_factor

func spawn_asteroid() -> void:
	var asteroid = asteroid_scene.instantiate()
	
	asteroid.og_speed = randi_range(ASTEROID_SPEED.x, ASTEROID_SPEED.y)
	asteroid.speed = asteroid.og_speed * speed_factor
	
	var spawn_x = randi_range(spawn_range_min.x, spawn_range_max.x)
	var spawn_y = randi_range(spawn_range_min.y, spawn_range_max.y)

	asteroid.global_position = Vector2(spawn_x, spawn_y)
	world.add_child(asteroid)
	asteroids_alive += 1
	
	var difficulty = randf()
	if difficulty <= 0.5:
		asteroid.health = easy["health"]
		asteroid.sprite.texture = easy["texture"]
	elif difficulty <= 0.85:
		asteroid.health = medium["health"]
		asteroid.sprite.texture = medium["texture"]
	else:
		asteroid.health = hard["health"]
		asteroid.sprite.texture = hard["texture"]

func start_spawn_timer() -> void:
	var random = randi_range(SPAWN_SPEED.x, SPAWN_SPEED.y)
	await get_tree().create_timer(random * spawn_factor).timeout
	spawn_asteroid()
	start_spawn_timer()
