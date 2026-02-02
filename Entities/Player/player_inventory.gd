class_name PlayerInventory extends Inventory
var inventory_ui : PanelContainer

func _ready() -> void:
	super()
	inventory_ui = $"../../../Menu/PanelContainer/MenuVBox/Inventory"

func add(item: InventoryItem, amnt: int) -> int:
	var ret = super(item, amnt)
	if ret != -1:
		inventory_ui.update(ret)
	return ret
	
func add_string(item: String, amnt: int) -> int:
	var ret = super(item, amnt)
	if ret != -1:
		inventory_ui.update(ret)
	return ret

func remove(item: InventoryItem, amnt: int) -> int:
	var ret = super(item, amnt)
	if ret != -1:
		inventory_ui.update(ret)
	return ret

func remove_string(item: String, amnt: int) -> int:
	var ret = super(item, amnt)
	if ret != -1:
		inventory_ui.update(ret)
	return ret
