extends Node2D

@onready var platform_layer: TileMapLayer = $platform_layer
@onready var building_layer: TileMapLayer = $building_layer_one
@onready var menu: CanvasLayer = $"../Menu"
@onready var player_inventory : PlayerInventory

var hotbar : Hotbar
var is_pressing_lmb = false
var is_pressing_rmb = false
var preview = null
var old_item = null

func _ready() -> void:
	player_inventory = get_tree().get_first_node_in_group("playerInventory")

func _unhandled_input(event: InputEvent) -> void:
	if not hotbar:
		hotbar = menu.hotbar
	
	if event.is_action("lmb"):
		is_pressing_lmb = event.is_pressed()
	
	if event.is_action("rmb"):
		is_pressing_rmb = event.is_pressed()

func _process(delta: float) -> void:
	if hotbar:
		var item = hotbar.get_item()
		if not old_item:
			old_item = item
		if item != old_item:
			if preview and preview.previewing:
				building_layer.remove_child(preview)
				preview = null
		if item and item.buildable:
			if item.scene:
				if preview == null:
					preview = item.scene.instantiate()
					building_layer.add_child(preview)
					preview.preview()
				elif !preview.previewing:
					preview = null
			else:
				if preview and preview.previewing:
					building_layer.remove_child(preview)
				preview = null
			if is_pressing_lmb:
				match item.action:
					"platform":
						platform_layer.place_platform()
				if preview and preview.can_place():
					preview.place()
		else:
			if preview and preview.previewing:
				building_layer.remove_child(preview)
				preview = null
		
		if is_pressing_rmb:
			remove()
		old_item = item

func remove():
	# get mouse choordinates
	var pos = building_layer.local_to_map(get_global_mouse_position())
	
	# check buildings first
	if pos in building_layer.building_choords:
		var building_to_remove = building_layer.building_choords[pos]
		if building_to_remove.removable:
			# remove all choordinates of building
			for coord in building_to_remove.coords:
				building_layer.building_choords.erase(coord)
			building_layer.remove_child(building_to_remove)
			player_inventory.add_string(building_to_remove.item, 1)
			building_to_remove.kill()
			building_to_remove.queue_free()
		return
	
	# check platforms last
	if pos in platform_layer.platforms and pos not in platform_layer.sacred:
		platform_layer.remove_platform()
		return
	
	# nothing to remove
	# print("nothing to remove")
