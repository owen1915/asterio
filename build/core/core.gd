extends Building
@onready var ship_menu: Panel = $CanvasLayer/ShipMenu

var start = true

func _ready() -> void:
	add_to_group("breakable")
	add_to_group("unremovable")
	super()

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	if len(main.building_manager.thrusters) == 0:
		return
	main.speed_manager.engines(start)
	start = !start
