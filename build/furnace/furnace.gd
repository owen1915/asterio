extends Storage

enum State {IDLE, PROCESSING}
var state = State.IDLE

var queue : Array = []
var item = null
var process_timer: SceneTreeTimer = null
var processing_started := false

@onready var sprite: AnimatedSprite2D = $Sprite

@export var smelting_speed = 5.0

func _ready() -> void:
	super()
	add_to_group("storage")
	add_to_group("furnace")

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			_process_idle()
		State.PROCESSING:
			_process_processing()

func _process_idle() -> void:
	if !queue.is_empty():
		item = queue.pop_front()
		sprite.play("processing")
		state = State.PROCESSING
		return
	sprite.play("idle")

func _process_processing() -> void:
	if !processing_started:
		processing_started = true
		process_timer = get_tree().create_timer(smelting_speed)
		process_timer.timeout.connect(_on_processing_done)

func _on_processing_done() -> void:
	add_to_storage(item.processed)
	item = null
	state = State.IDLE
	processing_started = false

func add_item(item) -> void:
	queue.push_back(item)

func add_to_storage(item: ItemData) -> bool:
	if empty:
		stored_texture.texture = item.texture
		empty = false

	if amnt_stored + 1 > max_storage:
		return false

	amnt_stored += 1
	update_label()
	storage.push_back(item)
	return true
