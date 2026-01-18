extends Node

var inventory_arr: Array[SlotData] = []
@onready var inventory_ui : GridContainer

func _ready() -> void:
	inventory_ui = get_tree().get_first_node_in_group("inventory").get_node("PanelContainer").get_node("GridContainer")
	pass

func add_item(item_data: ItemData, quantity: int) -> void:
	for i in range(len(inventory_arr)):
		if inventory_arr[i].item_data.name == name:
			inventory_arr[i].quantity += quantity
			inventory_ui.update_inventory(item_data, quantity)
			return
			
	# not already in inventory
	var slot := SlotData.new()
	slot.item_data = item_data
	slot.quantity = quantity
	inventory_arr.append(slot)
	inventory_ui.update_inventory(item_data, quantity)
