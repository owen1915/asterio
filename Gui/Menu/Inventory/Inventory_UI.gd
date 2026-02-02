class_name InventoryUI extends Control
@onready var panel_container: PanelContainer = $PanelContainer
@onready var gc: GridContainer = $GridContainer
@onready var menu: CanvasLayer = $"../../.."
@onready var hotbar: PanelContainer = $"../../../Hotbar"

var player_inventory : PlayerInventory
var children : Array

func _ready():
	visible = false
	player_inventory = get_tree().get_first_node_in_group("playerInventory")
	children = gc.get_children()

func update(index):
	children[index].update_item(player_inventory.inventory[index])
	if children[index].get_index() >= 0 and children[index].get_index() <= 7:
		hotbar.update_all()

func _process(delta: float):
	for c in children:
		if c.clicked:
			c.control.global_position = get_global_mouse_position()

func check_swap(button: InventoryButton, point: Vector2):
	for c in children:
		if c.get_global_rect().has_point(point):
			# found a child so perform swap
			perform_swap(button, c)
			return

func perform_swap(button1: InventoryButton, button2: InventoryButton):
	var index_a = button1.get_index()
	var index_b = button2.get_index()	
	gc.move_child(button1, index_b)
	gc.move_child(button2, index_a)
	hotbar.update_all()
