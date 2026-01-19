extends Node2D
class_name Game

var item_selected : ItemData

@onready var player: Player = $Player
@onready var inventory_container = $Inventory/PanelContainer/GridContainer
@onready var building_manager: Node2D = $BuildingManager

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	pass

func get_item() -> ItemData:
	return inventory_container.get_item_selected()
