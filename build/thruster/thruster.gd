extends Building

func _ready() -> void:
	add_to_group("breakable")
	add_to_group("anti-platform")
	super()
