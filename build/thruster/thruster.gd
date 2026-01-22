extends Building
@onready var sprite: AnimatedSprite2D = $sprite

var running = false
var started = false
var additional_speed = 3
var speed_manager = null


func _ready() -> void:
	add_to_group("breakable")
	add_to_group("anti-platform")
	super()
	speed_manager = main.speed_manager

func _process(delta: float) -> void:
	if not_ghost and started and not running:
		sprite.play("start_up")
		

func kill() -> void:
	speed_manager.remove_speed(additional_speed)
	super()
	
func remove() -> void:
	speed_manager.remove_speed(additional_speed)
	super()

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "start_up":
		sprite.play("full_speed")
		running = true
		speed_manager.add_speed(additional_speed)
	if sprite.animation == "wind_down":
		sprite.play("default")
		running = false
		started = false
		speed_manager.remove_speed(additional_speed)
