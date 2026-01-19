class_name Building extends StaticBody2D

var item_data : ItemData
var not_ghost = false
@export var max_health = 100
var health
@onready var building_manager = null
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	health = max_health
	if texture_progress_bar:
		texture_progress_bar.max_value = max_health
		texture_progress_bar.value = health
		texture_progress_bar.visible = false

func kill() -> void:
	building_manager = get_tree().get_first_node_in_group("building_manager")
	if global_position in building_manager.buildings:
		building_manager.buildings.erase(global_position)
	elif global_position in building_manager.platforms:
		building_manager.platforms.erase(global_position)
	
	queue_free()

func take_damage(damage):
	health -= damage
	update_progress_bar()
	if health <= 0:
		kill()

func update_progress_bar() -> void:
	texture_progress_bar.value = health
	
	if health < max_health:
		texture_progress_bar.visible = true
	else:
		texture_progress_bar.visible = false
