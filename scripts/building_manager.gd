extends Node2D

@onready var main: Game = $".."
@onready var world: Node2D = $"../World"

var scene: Node
var instantiated = false
var can_place = true
var curr_item = null

# Separate layers
var platforms = {}   # Vector2 -> Node
var buildings = {}   # Vector2 -> Node
var core_four = {}

# Removal state
var removing = false
var remove_timer = 0.0
const REMOVE_TIME = 0.25

var grid = 16

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var anchor_x = floor(mouse_pos.x / grid) * grid + grid / 2
	var anchor_y = floor(mouse_pos.y / grid) * grid + grid / 2
	var anchor_pos = Vector2(anchor_x, anchor_y)
	_handle_removal(delta, anchor_pos)
	if not main.get_item():
		if scene:
			world.remove_child(scene)
			instantiated = false
		return
	
	if not curr_item or main.get_item() != curr_item:
		if scene:
			world.remove_child(scene)
		curr_item = main.get_item()
		print("reset")
		instantiated = false
		
	var half = curr_item.tile_size / 2
	var visual_pos = anchor_pos + Vector2(half - grid / 2, half - grid / 2)
	

	if scene:
		scene.z_index = 100
		if can_place:
			scene.modulate = Color(0.3, 1.0, 0.5, 0.5) 
		else:
			scene.modulate = Color(1.0, 0.3, 0.3, 0.5)
	
	# Update can_place based on item type
	if curr_item:
		can_place = _can_place_at(anchor_pos, curr_item)
	
	if curr_item and curr_item.buildable and !instantiated:
		scene = curr_item.scene.instantiate()
		world.add_child(scene)
		instantiated = true
	elif instantiated:
		scene.global_position = visual_pos
	if (curr_item == null or !curr_item.buildable) and scene:
		scene.queue_free()
		instantiated = false
	
	if Input.is_action_just_pressed("placed") and curr_item and curr_item.buildable and can_place:
		place_item(anchor_pos)

func _can_place_at(anchor_pos: Vector2, item_data: ItemData) -> bool:
	if item_data.item_name == "platform":
		# Platforms can only go on empty ground and next to other platform
		if anchor_pos in platforms:
			return false
			
		var offset = 16
		var neighbors = [
			anchor_pos + Vector2(offset, 0), # right
			anchor_pos - Vector2(offset, 0), # left
			anchor_pos + Vector2(0, offset), # down
			anchor_pos - Vector2(0, offset) # up
		]
		for n in neighbors:
			if n in platforms:
				return true
		return false
	else:
		# Buildings need a platform underneath and no existing building
		if item_data.tile_size == 16:
			var has_platform = anchor_pos in platforms
			var no_building = not anchor_pos in buildings
			return has_platform and no_building
		elif item_data.tile_size == 32:
			var offset = 16
			var footprint = [
				anchor_pos + Vector2(0, 0), # current tile
				anchor_pos + Vector2(offset, 0), # right tile
				anchor_pos + Vector2(0, offset), # bottom tile
				anchor_pos + Vector2(offset, offset) # bottom right tile
			]
			
			for n in footprint:
				if n not in platforms:
					return false
			return true
		return false

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
		if building_node.is_in_group("unremovable"):
			return
		var item_data = building_node.item_data
		building_node.queue_free()
		buildings.erase(position)
		main.player.inventory.add_item(item_data, 1)
		return
	
	# Then platforms (bottom layer)
	if position in platforms and position not in core_four:
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
	if not item_data:
		return
		
	var new_scene = item_data.scene.instantiate()
	new_scene.item_data = item_data
	
	var half = item_data.tile_size / 2
	var visual_pos = position + Vector2(half - grid / 2, half - grid / 2)
	new_scene.global_position = visual_pos
	new_scene.not_ghost = true
	world.add_child(new_scene)
	
	# Add to correct dictionary
	if item_data.item_name == "platform":
		platforms[position] = new_scene
	else:
		buildings[position] = new_scene
	
	main.player.inventory.remove_item(item_data, 1)
