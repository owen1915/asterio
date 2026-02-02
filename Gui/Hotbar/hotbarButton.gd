extends Button

@onready var image: TextureRect = $Background/Image
@onready var quantity: Label = $Background/Quantity

var inventoryItem : InventoryItem

func update(item):
	if item:
		image.texture = item.texture
		quantity.text = str(item.quantity)
		inventoryItem = item
	else:
		image.texture = null
		quantity.text = ""
		inventoryItem = null
