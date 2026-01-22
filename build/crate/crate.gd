class_name Crate extends Storage
@onready var claw_to: Marker2D = $claw_to

func _ready() -> void:
	add_to_group("crates")
	add_to_group("storage")
	super()

func add_item(item) -> void:
	super.add(item, storage)
