class_name CraftingButton extends Button

@export var crafting_item : CraftingItem
@onready var item_texture: TextureRect = $TextureRect/Control/ItemTexture
@onready var item_quantity: Label = $TextureRect/Control/ItemQuantity

var playerInventory : PlayerInventory

func _ready() -> void:
	playerInventory = get_tree().get_first_node_in_group("playerInventory")
	if crafting_item:
		tooltip_text = crafting_item.tooltip
		item_texture.texture = crafting_item.inventoryItem.texture
		item_quantity.text = str(crafting_item.makes)

func craft_item(add_item) -> void:
	if not crafting_item:
		return
	
	var temp = crafting_item.requires.duplicate()
	
	var index = 0
	for item in playerInventory.inventory:
		if item and item.name in temp:
			if item.quantity >= temp[item.name]:
				temp.erase(item.name)
	
	if temp.is_empty():
		for item in crafting_item.requires:
			playerInventory.remove_string(item, crafting_item.requires[item])
		playerInventory.add(add_item, crafting_item.makes)
