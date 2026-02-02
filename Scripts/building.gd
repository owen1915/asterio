class_name Building extends StaticBody2D

@onready var building_layer_one : TileMapLayer
@onready var platform_layer : TileMapLayer
@onready var player_inventory : PlayerInventory

var previewing = false
var original_color : Color
var coords : Array = []

@export var removable = true
@export var TileSize = 16
@export var item : String

func _ready() -> void:
	building_layer_one = get_tree().get_first_node_in_group("buildingLayerOne")
	platform_layer = get_tree().get_first_node_in_group("platformLayer")
	player_inventory = get_tree().get_first_node_in_group("playerInventory")
	original_color = modulate

func _process(delta: float) -> void:
	if previewing:
		if !can_place():
			modulate = Color(100, 0, 0, 0.5)
		else:
			modulate = Color(original_color.r, original_color.g, original_color.b, 0.5)
		var offset = Vector2i(TileSize/2, TileSize/2)
		var pos = building_layer_one.local_to_map(get_global_mouse_position())
		global_position = (pos * Vector2i(16, 16)) + offset

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("lmb") and can_place() and event.is_pressed():
#		place()

func place():
	previewing = false
	add_building()
	
	modulate = Color(original_color.r, original_color.g, original_color.b, 1)
	player_inventory.remove_string(item, 1)

func preview():
	previewing = true

func can_place() -> bool:
	var area = get_area()
	for a in area:
		if a in building_layer_one.building_choords:
			return false
	return true

func get_area() -> Array:
	var area = []
	
	var real_pos = get_real_pos()
	
	if TileSize == 32:
		area.append(real_pos)
		area.append(real_pos + Vector2i(1, 0))
		area.append(real_pos + Vector2i(0, 1))
		area.append(real_pos + Vector2i(1, 1))
	else:
		area.append(real_pos)
	return area

func get_area_of_above_two() -> Array:
	var area = []
	
	var real_pos = get_real_pos()
	area.append(real_pos - Vector2i(0, 1))
	area.append(real_pos + Vector2i(1, -1))
	return area

func get_real_pos() -> Vector2i:
	var pos = building_layer_one.local_to_map(global_position)
	if TileSize == 32:
		pos -= Vector2i(1, 1)
	return pos

func add_building():
	var area = get_area()
	for a in area:
		building_layer_one.building_choords[a] = self
		coords.append(a)
	collision_layer = 3

func kill():
	pass
