extends Entity
class_name Player

@onready var jet: Sprite2D = $new_flame
@onready var inventory: Node = $Inventory

const SPACE_PLATFORM = preload("res://items/platform.tres")
const SPIKE = preload("res://items/spike.tres")
const CORE = preload("res://items/core.tres")
const TURRET = preload("res://items/gun_turret.tres")
const THRUSTER = preload("res://items/thruster.tres")
const CLAW = preload("res://items/claw.tres")
const CRATE = preload("res://items/crate.tres")

func _ready() -> void:
	inventory.add_item(SPACE_PLATFORM, 99)
	inventory.add_item(CRATE, 99)
	#inventory.add_item(CORE, 1)
	inventory.add_item(TURRET, 99)
	inventory.add_item(THRUSTER, 99)
	inventory.add_item(CLAW, 99)
	inventory.add_item(SPIKE, 99)
	super()
	
func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("w"):
		dir.y = -1
	elif Input.is_action_pressed("s"):
		dir.y = 1
	
	if Input.is_action_pressed("a"):
		dir.x = -1
	elif Input.is_action_pressed("d"):
		dir.x = 1

	velocity = dir.normalized() * speed
	if velocity != Vector2.ZERO:
		var target_angle = velocity.angle() + (PI / 2)
		rotation = lerp_angle(rotation, target_angle, 8.0 * delta)
		jet.visible = true
	else:
		jet.visible = false
		
	super(delta)
