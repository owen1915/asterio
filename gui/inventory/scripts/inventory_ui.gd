extends Control
@onready var inventory_slot: Button = $InventorySlot

var slot = preload("res://gui/inventory/InventorySlot.tscn")
var selected_slot = -1

var swap = null

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

func update_selected_slot(new_slot) -> void:
	if new_slot == selected_slot:
		var index = 1
		for c in get_children():
			if index == new_slot:
				c.release_focus()
				break
			index += 1
		new_slot = 0
	
	var index = 1
	for c in get_children():
		if index == new_slot:
			c.grab_focus()
			break
		index += 1
	selected_slot = new_slot

func clear_inventory() -> void:
	for c in get_children():
		c.item_data = null
		c.get_node("TextureRect").texture = null
		c.get_node("Label").text = ""
		c.empty = true
		
func clear_slot() -> void:
	var index = 1
	for c in get_children():
		if index == selected_slot:
			c.item_data = null
			c.get_node("TextureRect").texture = null
			c.get_node("Label").text = ""
			c.empty = true
			return
		index += 1

func update_inventory(item_data, quantity) -> void:
	for c in get_children():
		if c.item_data == item_data:
			if quantity <= 0:
				# COMPLETELY RESET THE SLOT
				c.item_data = null
				c.get_node("TextureRect").texture = null
				c.get_node("Label").text = ""
				c.empty = true 
				return
			c.get_node("Label").text = str(quantity)
			return
	
	# If not found, add to first empty slot
	for c in get_children():
		if c.empty:
			c.item_data = item_data
			c.get_node("TextureRect").texture = item_data.texture
			c.get_node("Label").text = str(quantity)
			c.empty = false
			return
	
func get_item_selected() -> ItemData:
	var index = 1
	for c in get_children():
		if index == selected_slot:
			return c.item_data
		index += 1
	return null
