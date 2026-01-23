class_name BuildingManager extends Node2D

@onready var main: Game = $".."
@onready var world: Node2D = $"../World"

var scene: Node
var instantiated = false
var can_place = true
var curr_item = null
var preview_rotation = 0

# Separate layers
var platforms = {}   # Vector2 -> Node
var buildings = {}   # Vector2 -> Node
var thrusters = {}
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
	
	if Input.is_action_just_pressed("rotate_building"):  # Add this action in project settings
		preview_rotation = (preview_rotation + 1) % 4
	
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
		instantiated = false
		
	var half = curr_item.tile_size / 2
	var visual_pos = anchor_pos + Vector2(half - grid / 2, half - grid / 2)
	

	if scene:
		scene.z_index = 100
		if curr_item and curr_item.is_rotatable:
			scene.rotation = preview_rotation * PI / 2
		
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
	if _is_blocked_by_building(anchor_pos):
		return false
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
			return anchor_pos in platforms
		elif item_data.tile_size == 32:
			if item_data.item_name == "thruster":
				var offset = 16
				var footprint = [
					anchor_pos + Vector2(0, 0), # current tile
					anchor_pos + Vector2(offset, 0), # right tile
					anchor_pos + Vector2(0, offset), # bottom tile
					anchor_pos + Vector2(offset, offset), # bottom right tile
					anchor_pos + Vector2(0, -offset), # above tile
					anchor_pos + Vector2(offset, -offset) # above right tile
				]
				
				if footprint[4] in platforms and footprint[5] in platforms:
					for i in range(4):
						if footprint[i] in platforms or footprint[i] in buildings:
							return false
				else:
					return false
				return true
			else:
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
					if n in buildings:
						return false
				return true
		return true

func _is_blocked_by_building(check_pos: Vector2) -> bool:
	var offset = 16
	
	# Check all buildings to see if check_pos is in their footprint
	for building_anchor in buildings.keys():
		var building = buildings[building_anchor]
		
		# Skip if not a valid building
		if not building or not building.item_data:
			continue
		
		# Check 2x2 buildings (like thrusters)
		if building.item_data.tile_size == 32:
			var footprint = [
				building_anchor + Vector2(0, 0),
				building_anchor + Vector2(offset, 0),
				building_anchor + Vector2(0, offset),
				building_anchor + Vector2(offset, offset)
			]
			if check_pos in footprint:
				return true
		# 1x1 buildings
		elif building.item_data.tile_size == 16:
			if check_pos == building_anchor:
				return true
	
	return false

func _handle_removal(delta: float, snapped_pos: Vector2) -> void:
	var can_remove = _can_remove_at(snapped_pos)
	
	if Input.is_action_pressed("remove") and can_remove:
		if not removing:
			removing = true
			remove_timer = 0.0
		
		remove_timer += delta
		if remove_timer >= REMOVE_TIME:
			_remove_top_layer(snapped_pos)
			_cancel_removal()
	else:
		if removing:
			_cancel_removal()

func _has_removable_at(position: Vector2) -> bool:
	return position in buildings or position in platforms

func _remove_top_layer(position: Vector2) -> void:
	# Buildings get removed first (top layer)
	if position in buildings:
		if position in thrusters:
			thrusters.erase(position)
		var building_node = buildings[position]
		var item_data = building_node.item_data
		building_node.remove()
		building_node.queue_free()
		buildings.erase(position)
		main.player.inventory.add_item(item_data, 1)
		return
	
	# Platforms
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
	if not item_data:
		return
		
	var new_scene = item_data.scene.instantiate()
	new_scene.item_data = item_data
	
	if item_data.is_rotatable:
		new_scene.set_rotation_direction(preview_rotation)
	
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
		
	if item_data.item_name == "thruster":
		thrusters[position] = new_scene
	
	if item_data.item_name == "claw":
		new_scene.starting_pos = new_scene.global_position
	
	main.player.inventory.remove_item(item_data, 1)

func _can_remove_at(position: Vector2) -> bool:
	"""Check if we're allowed to remove what's at this position"""
	
	# Can't remove if nothing there
	if position not in buildings and position not in platforms:
		return false
	
	# Buildings - check if it's marked unremovable
	if position in buildings:
		var building_node = buildings[position]
		if building_node.is_in_group("unremovable"):
			return false
		return true
	
	# Platforms - check multiple conditions
	if position in platforms:
		# Can't remove core platforms
		if position in core_four:
			return false
		
		# Can't remove if it has buildings on it
		if _has_building_on_platform(position):
			return false
		
		# Can't remove if it would disconnect other platforms
		if _would_disconnect_platforms(position):
			return false
		
		return true
	
	return false

func _has_building_on_platform(platform_pos: Vector2) -> bool:
	"""Check if any building depends on this platform"""
	var offset = 16
	
	for building_anchor in buildings.keys():
		var building = buildings[building_anchor]
		
		if not building or not building.item_data:
			continue
		
		var building_footprint = []
		
		# Get footprint based on building type
		if building.item_data.item_name == "thruster":
			# Thruster needs the 2 platforms directly above it
			building_footprint = [
				building_anchor + Vector2(0, -offset),      # above-left
				building_anchor + Vector2(offset, -offset)  # above-right
			]	
		elif building.item_data.tile_size == 32:
			# 2x2 building
			building_footprint = [
				building_anchor + Vector2(0, 0),
				building_anchor + Vector2(offset, 0),
				building_anchor + Vector2(0, offset),
				building_anchor + Vector2(offset, offset)
			]
		elif building.item_data.tile_size == 16:
			# 1x1 building
			building_footprint = [building_anchor]
		
		# If this building needs this platform
		if platform_pos in building_footprint:
			return true
	
	return false

func _would_disconnect_platforms(platform_pos: Vector2) -> bool:
	"""Check if removing this platform would disconnect others from core"""
	var offset = 16
	
	# Get neighbors of the platform we want to remove
	var neighbors = [
		platform_pos + Vector2(offset, 0),
		platform_pos - Vector2(offset, 0),
		platform_pos + Vector2(0, offset),
		platform_pos - Vector2(0, offset)
	]
	
	# Filter to only platform neighbors
	var platform_neighbors = []
	for n in neighbors:
		if n in platforms:
			platform_neighbors.append(n)
	
	# If no neighbors, safe to remove
	if len(platform_neighbors) == 0:
		return false
	
	# Temporarily remove this platform and check connectivity
	var temp_platforms = platforms.duplicate()
	temp_platforms.erase(platform_pos)
	
	# Check if all neighbors are still connected to core
	for neighbor in platform_neighbors:
		if not _is_connected_to_core(neighbor, temp_platforms):
			return true  # Would disconnect this neighbor
	
	return false

func _is_connected_to_core(start_pos: Vector2, platform_dict: Dictionary) -> bool:
	"""Check if a position can reach core_four through platform_dict"""
	var visited = []
	var to_check = [start_pos]
	var offset = 16
	
	while len(to_check) > 0:
		var current = to_check.pop_front()
		
		if current in visited:
			continue
		
		visited.append(current)
		
		# Found connection to core
		if current in core_four:
			return true
		
		# Check neighbors
		var neighbors = [
			current + Vector2(offset, 0),
			current - Vector2(offset, 0),
			current + Vector2(0, offset),
			current - Vector2(0, offset)
		]
		
		for neighbor in neighbors:
			if neighbor in platform_dict and neighbor not in visited:
				to_check.append(neighbor)
	
	return false

func has_building_at(check_pos: Vector2) -> Building:
	# Direct anchor check
	if check_pos in buildings:
		return buildings[check_pos]
	
	# Check if position is within a 2x2 building's footprint
	var offset = 16
	for building_anchor in buildings.keys():
		var building = buildings[building_anchor]
		if not building or not building.item_data:
			continue
		
		if building.item_data.tile_size == 32:
			var footprint = [
				building_anchor,
				building_anchor + Vector2(offset, 0),
				building_anchor + Vector2(0, offset),
				building_anchor + Vector2(offset, offset)
			]
			if check_pos in footprint:
				return building
	
	return null

func anchor_to_visual(anchor_pos: Vector2, tile_size: int) -> Vector2:
	var offset = tile_size / 2 - grid / 2
	return anchor_pos + Vector2(offset, offset)

func visual_to_anchor(visual_pos: Vector2, tile_size: int) -> Vector2:
	var offset = tile_size / 2 - grid / 2
	return visual_pos - Vector2(offset, offset)
