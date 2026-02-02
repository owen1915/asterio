extends Button

const HOVER = preload("res://Gui/Menu/MenuBar/hover.png")
const NOT_PRESSED = preload("res://Gui/Menu/MenuBar/not_pressed.png")
const PRESSED = preload("res://Gui/Menu/MenuBar/pressed.png")

@onready var texture_rect: TextureRect = $TextureRect
var on = false

func _ready() -> void:
	update_texture()

func update_texture():
	if on:
		texture_rect.texture = PRESSED
	else:
		texture_rect.texture = NOT_PRESSED
