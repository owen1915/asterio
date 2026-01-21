extends Entity

var item_data = load("res://items/iron.tres")
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	add_to_group("Ore")
	super()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("claws"):
		area_2d.set_deferred("monitoring", false)
	else:
		queue_free()
