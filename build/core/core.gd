extends Building
@onready var ship_menu: Panel = $CanvasLayer/ShipMenu

func _ready() -> void:
	add_to_group("breakable")
	add_to_group("unremovable")
	super()


func _on_button_pressed() -> void:
	pass
