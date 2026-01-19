extends Building
@onready var sprite: AnimatedSprite2D = $sprite

var started = false

func _ready() -> void:
	add_to_group("breakable")
	add_to_group("anti-platform")
	super()

func _process(delta: float) -> void:
	if not_ghost and !started:
		sprite.play("start_up")
		started = true

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "start_up":
		sprite.play("full_speed")
