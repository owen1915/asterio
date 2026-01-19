extends Building

func _ready() -> void:
	add_to_group("spikes")

func take_damage(damage):
	health -= damage
	if health <= 0:
		kill()
