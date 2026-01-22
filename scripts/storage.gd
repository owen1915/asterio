class_name Storage extends Building

var storage : Array = []
@onready var stored_texture: TextureRect = $StoredTexture
@onready var quantity_label: Label = $StoredTexture/QuantityLabel

var amnt_stored = 0
var max_storage = 99
var storing_item_name = ""
var empty = true
var double_digits_seen = false

func add(item: ItemData, array: Array) -> bool:
	if empty:
		stored_texture.texture = item.texture
		amnt_stored += 1
		update_label()
		storing_item_name = item.item_name
		array.push_back(item)
		empty = false
		return true

	if storing_item_name != item.item_name:
		return false
	
	if amnt_stored + 1 > max_storage:
		return false
	
	amnt_stored += 1
	update_label()
	if !double_digits_seen and amnt_stored > 9:
		quantity_label.global_position -= Vector2(3, 0)
		double_digits_seen = true
	
	array.push_back(item)
	return true

func update_label() -> void:
	quantity_label.text = str(amnt_stored)

func remove_item() -> bool:
	if empty:
		return false
	
	if amnt_stored > 1:
		amnt_stored -= 1
		update_label()
		return true
		
	amnt_stored = 0
	storing_item_name = ""
	empty = true
	double_digits_seen = false
	quantity_label.text = ""
	stored_texture.texture = null
	return true
