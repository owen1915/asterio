extends Camera2D

@onready var player : Player

@export var min_zoom = 3.0
@export var max_zoom = 6.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.lerp(
		player.global_position,
		10 * delta
	)
	
	if Input.is_action_just_pressed("mscrollup"):
		var new_zoom = min(max_zoom, zoom.x + 1)
		zoom.x = new_zoom
		zoom.y = new_zoom
	elif Input.is_action_just_pressed("mscrolldown"):
		var new_zoom = max(min_zoom, zoom.x - 1)
		zoom.x = new_zoom
		zoom.y = new_zoom
	
