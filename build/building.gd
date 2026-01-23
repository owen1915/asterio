class_name Building extends StaticBody2D

var item_data : ItemData
var not_ghost = false
@export var max_health = 100
var health
@onready var building_manager = null
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var rotation_dir = 0
@onready var main

func _ready() -> void:
	main = get_tree().get_first_node_in_group("main")
	building_manager = main.building_manager
	health = max_health
	if texture_progress_bar:
		texture_progress_bar.max_value = max_health
		texture_progress_bar.value = health
		texture_progress_bar.visible = false

func remove() -> void:
	pass

func kill() -> void:
	# Convert visual position back to anchor position
	var grid = 16
	var half = item_data.tile_size / 2
	var anchor_pos = global_position - Vector2(half - grid / 2, half - grid / 2)
	
	# Remove from correct dictionary using anchor position
	if anchor_pos in building_manager.buildings:
		building_manager.buildings.erase(anchor_pos)
		if item_data.item_name == "thruster":
			building_manager.thrusters.erase(anchor_pos)
	elif anchor_pos in building_manager.platforms:
		building_manager.platforms.erase(anchor_pos)
	
	
	queue_free()

func take_damage(damage):
	health -= damage
	if texture_progress_bar:
		update_progress_bar()
	if health <= 0:
		kill()

func update_progress_bar() -> void:
	texture_progress_bar.value = health
	
	if health < max_health:
		texture_progress_bar.visible = true
	else:
		texture_progress_bar.visible = false

func set_rotation_direction(dir: int) -> void:
	rotation_dir = dir
	rotation = dir * PI / 2
	_on_rotation_changed()

func _on_rotation_changed() -> void:
	# Override in child classes
	pass

# Helper to get directional offset based on rotation
func get_directional_offset(local_dir: Vector2) -> Vector2:
	match rotation_dir:
		0:  # North (default)
			return local_dir
		1:  # East (90° clockwise)
			return Vector2(-local_dir.y, local_dir.x)
		2:  # South (180°)
			return Vector2(-local_dir.x, -local_dir.y)
		3:  # West (270° clockwise)
			return Vector2(local_dir.y, -local_dir.x)
	return local_dir
