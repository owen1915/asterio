extends TileMapLayer
@onready var player: CharacterBody2D = $"../Player"
@onready var player_inventory: PlayerInventory = $"../Player/Player_Inventory"
@onready var building_layer_one: TileMapLayer = $"../building_layer_one"

const PLATFORM_INVENTORY = preload("res://Resources/Items/Platform/PlatformInventory.tres")

var sacred : Array = []
var platforms : Array = []

func _ready() -> void:
	sacred = get_used_cells()
	platforms = get_used_cells()

func place_platform():
	var mouse_pos = local_to_map(get_global_mouse_position())
	if can_place_platform(mouse_pos):
		if player_inventory.remove(PLATFORM_INVENTORY, 1) != -1:
			set_cells_terrain_connect([mouse_pos], 0, 0, false)
			print(mouse_pos)
			platforms.append(mouse_pos)

func remove_platform():
	var mouse_pos = local_to_map(get_global_mouse_position())
	if can_remove_platform(mouse_pos):
		set_cells_terrain_connect([mouse_pos], 0, -1)
		platforms.erase(mouse_pos)
		player_inventory.add(PLATFORM_INVENTORY, 1)

func can_remove_platform(coord: Vector2i) -> bool:
	var player_pos = local_to_map(player.collision_shape_2d.global_position)
	if coord == player_pos:
		return false
	
	var surronding = get_surrounding_cells(player_pos)
	for cell in surronding:
		if cell == coord:
			return false
	
	if coord in sacred:
		return false
	
	if coord in platforms:
		return true
	
	return false

func can_place_platform(coord: Vector2i) -> bool:
	if coord in platforms:
		return false
	
	if coord in building_layer_one.building_choords:
		return false
	
	var surronding = get_surrounding_cells(coord)
	for cell in surronding:
		if cell in platforms:
			return true
	
	return false
