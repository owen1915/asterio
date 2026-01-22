extends Building

enum State { IDLE, EXTENDING, RETRACTING, DELIVERING }

static var claimed_ore: Dictionary = {}

var ore_queue: Array = []  # UNTYPED - prevents crash on freed refs
var crates: Array = []
var current_ore: Node2D = null
var state: State = State.IDLE
var closest_crate = null

@onready var line: Line2D = $line
@onready var claw_sprite: Sprite2D = $claw/Sprite2D
@onready var range_indicator: Sprite2D = $Range/range
@onready var claw: CharacterBody2D = $claw
@onready var starting_pos: Vector2 = claw.global_position
@onready var base_anchor: Marker2D = $body/base_anchor
@onready var claw_anchor: Marker2D = $claw/Sprite2D/claw_anchor
@onready var world : Node2D
@onready var range: Area2D = $Range

const RETRACT_THRESHOLD := 5.0

func _ready() -> void:
	add_to_group("breakable")
	super()
	world = main.world

func _process(delta: float) -> void:
	_update_range_visibility()
	
	if not not_ghost:
		return
	
	match state:
		State.IDLE:
			_process_idle()
		State.EXTENDING:
			_process_extending()
		State.RETRACTING:
			_process_retracting()
		State.DELIVERING:
			_process_deliver()

func _process_deliver() -> void:
	if _is_ore_valid(current_ore):
		current_ore.global_position = claw.global_position
	
	if closest_crate == null:
		closest_crate = _get_closest_crate()
	else:
		_look_at_target(closest_crate.global_position)
		_move_toward(closest_crate.global_position)

func _process_idle() -> void:
	claw.velocity = Vector2.ZERO
	_cleanup_invalid_ore()
	
	for ore in ore_queue:
		if _try_claim_ore(ore):
			current_ore = ore
			state = State.EXTENDING
			break

func _process_extending() -> void:
	if not _is_ore_valid(current_ore):
		_release_current_ore()
		line.visible = false
		state = State.IDLE
		return
	
	draw_line_between()
	_look_at_target(current_ore.global_position)
	_move_toward(current_ore.global_position)

func _process_retracting() -> void:
	if _is_ore_valid(current_ore) and claw.global_position.distance_to(starting_pos) <= RETRACT_THRESHOLD:
		state = State.DELIVERING
		claw.velocity = Vector2.ZERO
		return
	
	if claw.global_position.distance_to(starting_pos) <= RETRACT_THRESHOLD:
		line.visible = false
		state = State.IDLE
		return
	
	_move_toward(starting_pos)
	
	if _is_ore_valid(current_ore):
		current_ore.global_position = claw.global_position

func _get_closest_crate() -> Building:
	var closest: Building = null
	var best_dist := INF
	var max_range: float = $Range/CollisionShape2D.shape.radius
	
	for crate in get_tree().get_nodes_in_group("crates"):
		if !crate.not_ghost:
			break
		var dist = global_position.distance_to(crate.global_position)
		if dist <= max_range and dist < best_dist:
			closest = crate
			best_dist = dist
	
	return closest

func _look_at_target(target: Vector2) -> void:
	claw_sprite.look_at(target)
	claw_sprite.rotation += PI / 2

func _move_toward(target: Vector2) -> void:
	line.visible = true
	var direction = (target - claw.global_position).normalized()
	draw_line_between()
	claw.velocity = direction * claw.speed

func _is_ore_valid(ore) -> bool: 
	return ore != null and is_instance_valid(ore) and ore.is_inside_tree()

func _is_ore_claimed(ore) -> bool:
	if not _is_ore_valid(ore):
		return true
	return ore.get_instance_id() in claimed_ore

func _try_claim_ore(ore) -> bool:
	if not _is_ore_valid(ore):
		return false
	if _is_ore_claimed(ore):
		return false
	claimed_ore[ore.get_instance_id()] = get_instance_id()
	return true

func _unclaim_ore(ore) -> void:
	if ore != null and is_instance_valid(ore):
		var ore_id = ore.get_instance_id()
		if ore_id in claimed_ore and claimed_ore[ore_id] == get_instance_id():
			claimed_ore.erase(ore_id)

func _cleanup_invalid_ore() -> void:
	var valid_queue: Array = []
	for ore in ore_queue:
		if _is_ore_valid(ore):
			valid_queue.append(ore)
	ore_queue = valid_queue

func _release_current_ore() -> void:
	_unclaim_ore(current_ore)
	_cleanup_invalid_ore()
	current_ore = null

func _deliver_ore() -> void:
	var ore_to_free = current_ore
	closest_crate.add_item(current_ore.item_data)
	_release_current_ore()
	if _is_ore_valid(ore_to_free):
		ore_to_free.queue_free()

func _update_range_visibility() -> void:
	range_indicator.visible = main.turret_range

func _on_range_body_entered(body: Node2D) -> void:
	if body is Crate:
		crates.append(body)
		return
	
	if not _is_ore_valid(body):
		return
	if body.is_in_group("Ore") and body not in ore_queue:
		ore_queue.push_back(body)

func _on_range_body_exited(body: Node2D) -> void:
	if body is Crate:
		crates.erase(body)
		return
	if not _is_ore_valid(body):
		_cleanup_invalid_ore()
		return
	if body not in ore_queue:
		return
	if body != current_ore:
		ore_queue.erase(body)

func _on_claw_area_body_entered(body: Node2D) -> void:
	if body == closest_crate and state == State.DELIVERING:
		_deliver_ore()
		line.visible = true
		closest_crate = null
		state = State.RETRACTING
	elif body == current_ore and state == State.EXTENDING:
		line.visible = true
		state = State.RETRACTING

func _exit_tree() -> void:
	_release_current_ore()

func draw_line_between():
	line.clear_points()
	var p1 = line.to_local(base_anchor.global_position)
	var p2 = line.to_local(claw_anchor.global_position)
	
	line.add_point(p1)
	line.add_point(p2)
