class_name Hotbar extends PanelContainer

var selected_button = -1
var buttons : Array

const UNSELECTED = preload("res://Gui/Hotbar/inventory_unselected.png")
const SELECTED = preload("res://Gui/Hotbar/inventory_selected.png")
@onready var inventory: InventoryUI = $"../PanelContainer/MenuVBox/Inventory"

func _ready() -> void:
	buttons = $"Hotbar Container".get_children()

func update_all():
	var index = 0
	for b in buttons:
		b.update(null)
	
	for c in inventory.gc.get_children():
		if index > buttons.size() - 1:
			return
		if c.inventoryItem:
			buttons[index].update(c.inventoryItem)
		index += 1

func update_by_index(index: int, item: InventoryItem):
	buttons[index].update(item) 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		change_button(0)
	elif Input.is_action_just_pressed("2"):
		change_button(1)
	elif Input.is_action_just_pressed("3"):
		change_button(2)
	elif Input.is_action_just_pressed("4"):
		change_button(3)
	elif Input.is_action_just_pressed("5"):
		change_button(4)
	elif Input.is_action_just_pressed("6"):
		change_button(5)
	elif Input.is_action_just_pressed("7"):
		change_button(6)
	elif Input.is_action_just_pressed("8"):
		change_button(7)
	
	if Input.is_action_just_pressed("switch_hotbar_left"):
		change_button((selected_button + 7) % 8)
	elif Input.is_action_just_pressed("switch_hotbar_right"):
		change_button((selected_button + 1) % 8)

func change_button(new_button):
	buttons[selected_button].get_node("Background").texture = UNSELECTED
	if new_button == selected_button:
		selected_button = -1
		return
		
	buttons[new_button].get_node("Background").texture = SELECTED
	selected_button = new_button

func get_item() -> InventoryItem:
	if selected_button == -1:
		return null
	return buttons[selected_button].inventoryItem
