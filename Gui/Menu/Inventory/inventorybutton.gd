class_name InventoryButton extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var item_texture: TextureRect = $TextureRect/Control/ItemTexture
@onready var item_quantity: Label = $TextureRect/Control/ItemQuantity
@onready var control: Control = $TextureRect/Control
@onready var inventory_ui: InventoryUI = $"../.."

var inventoryItem = null
var reset = true
var clicked = false
var og_pos : Vector2

func update_item(item):
	inventoryItem = item
	update()

func update():
	if inventoryItem:
		item_texture.texture = inventoryItem.texture
		item_quantity.text = str(inventoryItem.quantity)
		tooltip_text = inventoryItem.name
	else:
		item_texture.texture = null
		item_quantity.text = ""
		tooltip_text = ""

func _on_button_up() -> void:
	clicked = false
	inventory_ui.check_swap(self, control.global_position)
	control.global_position = og_pos
	control.z_index = 0

func _on_pressed() -> void:
	if not inventoryItem:
		return
	og_pos = control.global_position
	control.z_index = 1
	clicked = true
