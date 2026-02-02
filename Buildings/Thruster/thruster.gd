extends Building

@onready var sprite: AnimatedSprite2D = $Sprite
var on = false
const added_velocity = 3 #3 km
var speed : Node

func _ready() -> void:
	super()
	speed = get_tree().get_first_node_in_group("speed")

func add_building():
	super()
	add_to_group("thrusters")
	if speed.thrusters_on:
		turn_on()

func can_place() -> bool:
	if !building_layer_one.has_no_platform(get_area()):
		return false
	
	if !building_layer_one.has_platform(get_area_of_above_two()):
		return false
	
	return super()

func turn_on():
	if !on:
		print(1)
		sprite.play("starting")
		await get_tree().create_timer(.1).timeout
		speed.speed += added_velocity * 0.33
		speed.update()
		sprite.frame = 1
		await get_tree().create_timer(.1).timeout
		speed.speed -= added_velocity * 0.33
		speed.speed += added_velocity * 0.66
		speed.update()
		sprite.frame = 2
		await get_tree().create_timer(.1).timeout
		speed.speed -= added_velocity * 0.66
		speed.speed += added_velocity * 0.88
		speed.update()
		sprite.frame = 3
		await get_tree().create_timer(.1).timeout
		speed.speed -= added_velocity * 0.88
		speed.speed += added_velocity
		speed.update()
		sprite.play("on")
	on = true

func turn_off():
	if on:
		sprite.play("ending")
		await get_tree().create_timer(.25).timeout
		speed.speed -= added_velocity
		speed.speed += added_velocity * 0.88
		speed.update()
		sprite.frame = 1
		await get_tree().create_timer(.15).timeout
		speed.speed -= added_velocity * 0.88
		speed.speed += added_velocity * 0.66
		speed.update()
		sprite.frame = 2
		await get_tree().create_timer(.1).timeout
		speed.speed -= added_velocity * 0.66
		speed.speed += added_velocity * 0.33
		speed.update()
		sprite.frame = 3
		await get_tree().create_timer(.05).timeout
		speed.speed -= added_velocity * 0.33
		speed.update()
		sprite.play("idle")
	on = false

func kill():
	if on:
		speed.speed -= added_velocity
		speed.update()
