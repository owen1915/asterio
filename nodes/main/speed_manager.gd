extends Node2D

var speed = 1.0
@onready var building_manager: Node2D = $"../BuildingManager"
@onready var speed_label: Label = $"../CanvasLayer/Panel/MarginContainer/VBoxContainer/SpeedLabel"
@onready var asteroid_manager: Node2D = $"../AsteroidManager"

func _ready() -> void:
	speed_label.text = "Speed: " + str(speed * 100) + "m/s"
	asteroid_manager.update_asteroid_stats()

func _process(delta: float) -> void:
	pass

func add_speed(new_speed) -> void:
	speed += new_speed
	speed_label.text = "Speed: " + str(speed * 100) + "m/s"
	asteroid_manager.update_asteroid_stats()

func remove_speed(new_speed) -> void:
	speed -= new_speed
	speed_label.text = "Speed: " + str(speed * 100) + "m/s"
	asteroid_manager.update_asteroid_stats()

func engines(start) -> void:
	if start:
		for n in building_manager.thrusters.values():
			n.started = true
	else:
		for n in building_manager.thrusters.values():
			if n.started:
				n.sprite.play("wind_down")
