extends Node2D
class_name Game

var item_selected : ItemData

@onready var player: Player = $Player
@onready var inventory_container = $Inventory/PanelContainer/GridContainer
@onready var building_manager: Node2D = $BuildingManager
@onready var speed_manager: Node2D = $SpeedManager
@onready var distance_label: Label = $CanvasLayer/Panel/MarginContainer/VBoxContainer/DistanceLabel
@onready var asteroids_per_sec: Label = $CanvasLayer/Panel/MarginContainer/VBoxContainer/AsteroidsPerSec
@onready var asteroid_manager: Node2D = $AsteroidManager

var distance_traveled := 0.0
var turret_range = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	distance_traveled += ((speed_manager.speed * 100) * delta)
	
	var distance_km = distance_traveled / 1000.0
	var distance_text = "%.1f" % distance_km + "km"
	distance_label.text = "Distance Travelled: " + distance_text
	
	var asteroid_per_text = 1 / (asteroid_manager.SPAWN_SPEED.x * asteroid_manager.spawn_factor)
	asteroids_per_sec.text = "Asteroids/Sec: " + str(asteroid_per_text)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("turret_range"):
		turret_range = !turret_range

func get_item() -> ItemData:
	return inventory_container.get_item_selected()
