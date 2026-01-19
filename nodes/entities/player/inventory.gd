extends Node

var inventory_arr: Array[SlotData] = []
@onready var inventory_ui : GridContainer

func _ready() -> void:
	inventory_ui = get_tree().get_first_node_in_group("inventory").get_node("PanelContainer").get_node("GridContainer")
	
func add_item(item_data: ItemData, quantity: int) -> void:
	for i in range(len(inventory_arr)):
		if inventory_arr[i].item_data.item_name == item_data.item_name:
			inventory_arr[i].quantity += quantity
			inventory_ui.update_inventory(item_data, inventory_arr[i].quantity)
			return
			
	# not already in inventory
	var slot := SlotData.new()
	slot.item_data = item_data
	slot.quantity = quantity
	inventory_arr.append(slot)
	inventory_ui.update_inventory(item_data, quantity)

func remove_item(item_data, remove_amnt) -> void:
	for i in range(inventory_arr.size()):
		if inventory_arr[i].item_data.item_name == item_data.item_name:
			inventory_arr[i].quantity -= remove_amnt
			
			if inventory_arr[i].quantity <= 0:
				# Item is gone!s
				inventory_arr.remove_at(i)
				# Tell the UI to refresh entirely or clear that slot
				inventory_ui.clear_inventory() 
				# Re-draw the remaining items (if you have a redraw function)
				# _repopulate_ui() 
			else:
				# Item still exists, just update the label
				inventory_ui.update_inventory(item_data, inventory_arr[i].quantity)
			return
	
	
