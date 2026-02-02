class_name Inventory extends Node

@export var inventory_size : int

var inventory : Array

const max_quantity = 99
const THRUSTER_INVENTORY = preload("res://Resources/Items/Thruster/ThrusterInventory.tres")

func _ready() -> void:
	for i in range(inventory_size):
		inventory.append(null)

func add(item: InventoryItem, amnt: int) -> int:
	if not item or not item.name:
		return -1
	
	var first_null = -1
	
	for i in range(inventory.size()):
		if inventory[i] and inventory[i].name == item.name:
			inventory[i].quantity += amnt
			return i
		if first_null == -1 and inventory[i] == null:
			first_null = i
	
	if first_null != -1:
		inventory[first_null] = item
		inventory[first_null].quantity = amnt
		return first_null
	return -1

func add_string(item: String, amnt: int) -> int:
	if not item:
		return -1
	
	var first_null = -1
	
	for i in range(inventory.size()):
		if inventory[i] and inventory[i].name == item:
			inventory[i].quantity += amnt
			return i
		if first_null == -1 and inventory[i] == null:
			first_null = i
	
	if first_null != -1:
		var new_item = Items.map[item]
		if new_item:
			inventory[first_null] = load(new_item)
			inventory[first_null].quantity = amnt
			return first_null
	return -1

func remove(item: InventoryItem, amnt: int) -> int:
	for i in range(inventory.size()):
		if inventory[i] and inventory[i].name == item.name:
			inventory[i].quantity -= amnt
			check_empty(i)
			return i
	return -1

func remove_string(item: String, amnt: int) -> int:
	for i in range(inventory.size()):
		if inventory[i] and inventory[i].name == item:
			inventory[i].quantity -= amnt
			check_empty(i)
			return i
	return -1

func check_empty(index: int):
	if inventory[index].quantity <= 0:
		inventory[index] = null
