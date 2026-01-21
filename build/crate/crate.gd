class_name Crate extends Building
@onready var claw_to: Marker2D = $claw_to

var storage : Array = []
@onready var quantity_label: Label = $QuantityLabel
@onready var stored_texture: TextureRect = $StoredTexture

var amnt_stored = 0
var max_storage = 99
var storing_item_name = ""
var empty = true
var double_digits_seen = false

func _ready() -> void:
	add_to_group("crates")
	super()

func add_to_storage(item: ItemData) -> bool:
	if empty:
		stored_texture.texture = item.texture
		amnt_stored += 1
		quantity_label.text = str(amnt_stored)
		storing_item_name = item.item_name
		empty = false
		return true

	if storing_item_name != item.item_name:
		return false
	
	if amnt_stored + 1 > max_storage:
		return false
	
	amnt_stored += 1
	quantity_label.text = str(amnt_stored)
	if !double_digits_seen and amnt_stored > 9:
		quantity_label.global_position -= Vector2(3, 0)
		double_digits_seen = true
	
	return true
