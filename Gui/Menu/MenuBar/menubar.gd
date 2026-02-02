extends PanelContainer

var curr_pressed = null
@onready var menu: CanvasLayer = $"../../.."
@onready var menu_inventory_button: Button = $HBoxContainer/MenuInventoryButton
@onready var menu_crafting_button: Button = $HBoxContainer/MenuCraftingButton
@onready var menu_equipment_button: Button = $HBoxContainer/MenuEquipmentButton
var menu_selected = ""

signal button_pressed

func _ready() -> void:
	_on_menu_inventory_button_pressed()

func _on_menu_inventory_button_pressed() -> void:
	clear()
	curr_pressed = menu_inventory_button
	menu_inventory_button.on = true
	menu_inventory_button.update_texture()
	menu_selected = "inv"
	emit_signal("button_pressed")

func _on_menu_crafting_button_pressed() -> void:
	clear()
	curr_pressed = menu_crafting_button
	menu_crafting_button.on = true
	menu_crafting_button.update_texture()
	menu_selected = "craft"
	emit_signal("button_pressed")

func _on_menu_equipment_button_pressed() -> void:
	clear()
	curr_pressed = menu_equipment_button
	menu_equipment_button.on = true
	menu_equipment_button.update_texture()
	menu_selected = "equipment"
	emit_signal("button_pressed")

func clear():
	menu_selected = ""
	menu_inventory_button.on = false
	menu_inventory_button.update_texture()
	menu_crafting_button.on = false
	menu_crafting_button.update_texture()
	menu_equipment_button.on = false
	menu_equipment_button.update_texture()
