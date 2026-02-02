extends Node2D

const SHOOTING_STAR = preload("res://Main/background/objects/moving/ShootingStar/ShootingStar.tscn")

func _ready() -> void:
	spawn_object()

func spawn_object():
	var star = SHOOTING_STAR.instantiate()
	var scale = randf_range(0.25, 1.25)
	star.scale = Vector2(scale, scale)
	star.global_position = Vector2(randi_range(800, 1250), randi_range(-300, -100))
	add_child(star)
	
	await get_tree().create_timer(randi_range(5, 10)).timeout
	spawn_object()
