class_name Building extends StaticBody2D

var item_data : ItemData
var not_ghost = false
@export var health = 100
@onready var building_manager = null

func _ready() -> void:
	pass

func kill() -> void:
	building_manager = get_tree().get_first_node_in_group("building_manager")
	if global_position in building_manager.buildings:
		building_manager.buildings.erase(global_position)
	elif global_position in building_manager.platforms:
		building_manager.platforms.erase(global_position)
	
	queue_free()
