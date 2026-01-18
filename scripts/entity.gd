extends CharacterBody2D
class_name Entity

# speed
@export var speed := 100

# health
@export var max_health := 100
var health := max_health

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
