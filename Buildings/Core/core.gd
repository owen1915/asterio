extends DefaultBuilding

var on = false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var speed: Node = $"../../../Speed"

func _on_button_pressed() -> void:
	on = !on
	if on:
		sprite.play("on")
	else:
		sprite.play("idle")
	speed.toggle_thrusters()
