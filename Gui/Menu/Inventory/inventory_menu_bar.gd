extends Control
@onready var press_inventory: TextureButton = $PanelContainer/HBoxContainer/PressInventory

func _ready() -> void:
	press_inventory.button_pressed = true
