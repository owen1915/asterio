extends Control
@onready var inventory_slot: Button = $InventorySlot

var slot = preload("res://gui/inventory/InventorySlot.tscn")
var selected_slot = -1

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		update_selected_slot(1)
	elif Input.is_action_just_pressed("2"):
		update_selected_slot(2)
	elif Input.is_action_just_pressed("3"):
		update_selected_slot(3)
	elif Input.is_action_just_pressed("4"):
		update_selected_slot(4)
	elif Input.is_action_just_pressed("5"):
		update_selected_slot(5)
	print(selected_slot)

func update_selected_slot(new_slot) -> void:
	var index = 1
	for c in get_children():
		if index == new_slot:
			c.button_pressed = true
		if index == selected_slot:
			c.button_pressed = false
		index += 1
	selected_slot = new_slot

func clear_inventory() -> void:
	for c in get_children():
		c.get_node("TextureRect").texture = null
		c.get_node("Label").text = ""

func update_inventory(item_data, quantity) -> void:
	for c in get_children():
		if c.item_data == item_data:
			c.get_node("Label").text = str(quantity)
			return
	
	for c in get_children():
		if c.empty:
			c.get_node("TextureRect").texture = item_data.texture
			c.get_node("Label").text = str(quantity)
			return
	
