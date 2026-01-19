extends Node2D

var target: Node2D = null
var damage = 0
var speed = 1500

func _ready():
	if target:
		var direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()

func _process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
	
	# Check if reached target
	if global_position.distance_to(target.global_position) < 10:
		hit_target()

func hit_target():
	if is_instance_valid(target):
		target.take_damage(damage)
	queue_free()
