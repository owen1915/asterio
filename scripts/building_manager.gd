extends Node2D

@onready var main: Game = $".."
@onready var world: Node2D = $"../World"

var scene: Node
var instantiated = false
var can_place = true

# Separate layers
var platforms = {}   # Vector2 -> Node
var buildings = {}   # Vector2 -> Node

# Removal state
var removing = false
var remove_timer = 0.0
const REMOVE_TIME = 0.25

func _process(delta: float) -> void:
	var tile_size = 16
	var half_tile = tile_size / 2
	var mouse_pos = get_global_mouse_position()
	var snapped_x = floor(mouse_pos.x / tile_size) * tile_size + half_tile
	var snapped_y = floor(mouse_pos.y / tile_size) * tile_size + half_tile
	var snapped_pos = Vector2(snapped_x, snapped_y)
	
	_handle_removal(delta, snapped_pos)
	
	if scene:
		scene.z_index = 100
		if can_place:
			scene.modulate = Color(0.3, 1.0, 0.5, 0.5) 
		else:
			scene.modulate = Color(1.0, 0.3, 0.3, 0.5)
	
	# Update can_place based on item type
	if main.get_item():
		can_place = _can_place_at(snapped_pos, main.get_item())
	
	if main.get_item() and main.get_item().buildable and !instantiated:
		scene = main.get_item().scene.instantiate()
		world.add_child(scene)
		instantiated = true
	elif instantiated:
		scene.global_position = snapped_pos
	if (main.get_item() == null or !main.get_item().buildable) and scene:
		scene.queue_free()
		instantiated = false
	
	if Input.is_action_just_pressed("placed") and main.get_item() and main.get_item().buildable and can_place:
		place_item(snapped_pos)

func _can_place_at(position: Vector2, item_data: ItemData) -> bool:
	if item_data.item_name == "platform":
		# Platforms can only go on empty ground
		return not position in platforms
	else:
		# Buildings need a platform underneath and no existing building
		var has_platform = position in platforms
		var no_building = not position in buildings
		return has_platform and no_building

func _handle_removal(delta: float, snapped_pos: Vector2) -> void:
	var has_something = _has_removable_at(snapped_pos)
	
	if Input.is_action_pressed("remove") and has_something:
		if not removing:
			removing = true
			remove_timer = 0.0
		
		remove_timer += delta
		if remove_timer >= REMOVE_TIME:
			_remove_top_layer(snapped_pos)
			_cancel_removal()  # Reset so they have to hold again for next layer
	else:
		if removing:
			_cancel_removal()

func _has_removable_at(position: Vector2) -> bool:
	return position in buildings or position in platforms

func _remove_top_layer(position: Vector2) -> void:
	# Buildings get removed first (top layer)
	if position in buildings:
		var building_node = buildings[position]
		var item_data = building_node.item_data
		building_node.queue_free()
		buildings.erase(position)
		main.player.inventory.add_item(item_data, 1)
		return
	
	# Then platforms (bottom layer)
	if position in platforms:
		var platform_node = platforms[position]
		var item_data = platform_node.item_data
		platform_node.queue_free()
		platforms.erase(position)
		main.player.inventory.add_item(item_data, 1)

func _cancel_removal() -> void:
	removing = false
	remove_timer = 0.0

func place_item(position: Vector2) -> void:
	var item_data = main.get_item()
	var new_scene = item_data.scene.instantiate()
	new_scene.item_data = item_data
	new_scene.global_position = position
	world.add_child(new_scene)
	
	# Add to correct dictionary
	if item_data.item_name == "platform":
		platforms[position] = new_scene
	else:
		buildings[position] = new_scene
	
	main.player.inventory.remove_item(item_data, 1)
