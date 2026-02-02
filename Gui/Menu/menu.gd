extends CanvasLayer

@onready var inventory: PanelContainer = $PanelContainer/MenuVBox/Inventory
@onready var menu_bar: PanelContainer = $PanelContainer/MenuVBox/MenuBar
@onready var panel_container: PanelContainer = $PanelContainer
@onready var crafting: PanelContainer = $PanelContainer/MenuVBox/Crafting
@onready var hotbar: Hotbar = $Hotbar
@onready var ship_panel: PanelContainer = $ShipPanel

var curr_menu = ""
var menu_open = false

var map : Dictionary = {}

func _ready() -> void:
	map["inv"] = inventory
	map["craft"] = crafting
	menu_bar.connect("button_pressed", Callable(self, "change_menu"))
	change_menu()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		menu_open = !menu_open
		
	panel_container.visible = menu_open

func change_menu():
	var new_menu = menu_bar.menu_selected
	if curr_menu != "":
		map[curr_menu].visible = false
	if new_menu in map:
		map[new_menu].visible = true
		curr_menu = new_menu
