extends Building

enum State {IDLE, GET, DELIVER}
var state = State.IDLE

var input = null
var output = null
var placed = false
@export var ROT_SPEED = PI

var item = null
@onready var inserter_head: CharacterBody2D = $InserterHead
@onready var resource: Marker2D = $InserterHead/resource
@onready var resource_texture: TextureRect = $InserterHead/resource/resource_texture

func _ready() -> void:
	super()
	add_to_group("inserters")

func _process(delta: float) -> void:
	if !not_ghost:
		return
	
	match state:
		State.IDLE:
			_process_idle(delta)
		State.GET:
			_process_get(delta)
		State.DELIVER:
			_process_deliver(delta)

func _process_idle(delta: float) -> void:
	if not input:
		get_input_building()
		return
	if not output:
		get_output_building()
		return
	
	var desired = (input.global_position - inserter_head.global_position).angle() + PI / 2
	rotate_to_building(input.global_position, delta)
	var reached = abs(angle_difference(inserter_head.rotation, desired)) < 0.01
	
	if reached:
		ROT_SPEED = ROT_SPEED * -1
		state = State.GET

func _process_get(delta: float) -> void:
	if item:
		var desired = (output.global_position - inserter_head.global_position).angle() + PI / 2
		rotate_to_building(output.global_position, delta)
		var reached = abs(angle_difference(inserter_head.rotation, desired)) < 0.01
		if reached:
			state = State.DELIVER
	else:
		if input.storage.size() > 0:
			item = input.storage.pop_front()
			input.remove_item()
			resource_texture.texture = item.texture

func _process_deliver(delta: float) -> void:
	output.add_item(item)
	item = null
	resource_texture.texture = null
	ROT_SPEED = ROT_SPEED * -1
	state = State.IDLE

func get_output_building() -> void:
	var look_up = building_manager.visual_to_anchor(global_position, 16)
	var temp = building_manager.has_building_at(look_up + Vector2(0, 16))
	if temp and temp.is_in_group("storage"):
		output = building_manager.buildings[look_up + Vector2(0, 16)]

func get_input_building() -> void:
	var look_up = building_manager.visual_to_anchor(global_position, 16)
	var temp = building_manager.has_building_at(look_up + Vector2(0, -16))
	if temp and temp.is_in_group("storage"):
		input = building_manager.buildings[look_up + Vector2(0, -16)]

func rotate_to_building(target: Vector2, delta: float) -> void:
	var desired = (target - inserter_head.global_position).angle() + PI / 2
	var diff = angle_difference(inserter_head.rotation, desired)
	
	var step = ROT_SPEED * delta
	inserter_head.rotation += clamp(diff, -step, step)
