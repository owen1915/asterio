extends Node2D

var platform = preload("res://build/platform/platform.tscn")
@onready var building_manager: Node2D = $"../BuildingManager"
var CORE = preload("res://build/core/core.tscn")

func _ready() -> void:
	# add platform to center of world
	var plat1 = platform.instantiate()
	var pos1 = Vector2(952.0, 536.0)
	plat1.global_position = pos1
	add_child(plat1)
	building_manager.platforms[pos1] = plat1
	
	var plat2 = platform.instantiate()
	var pos2 = Vector2(952.0, 536.0) + Vector2(16, 0)
	plat2.global_position = pos2
	add_child(plat2)
	building_manager.platforms[pos2] = plat2
	
	var plat3 = platform.instantiate()
	var pos3 = Vector2(952.0, 536.0) + Vector2(0, 16)
	plat3.global_position = pos3
	add_child(plat3)
	building_manager.platforms[pos3] = plat3
	
	var plat4 = platform.instantiate()
	var pos4 = Vector2(952.0, 536.0) + Vector2(16, 16)
	plat4.global_position = pos4
	add_child(plat4)
	building_manager.platforms[pos4] = plat4
	
	building_manager.core_four[pos1] = plat1
	building_manager.core_four[pos2] = plat2
	building_manager.core_four[pos3] = plat3
	building_manager.core_four[pos4] = plat4
	
	# add core
	var core = CORE.instantiate()
	core.item_data = preload("res://items/core.tres")
	core.global_position = pos1 + Vector2(8, 8)
	core.not_ghost = true
	add_child(core)
	building_manager.buildings[pos1] = core
	
