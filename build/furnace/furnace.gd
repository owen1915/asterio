extends Building

enum State {IDLE, PROCESSING}
var state = State.IDLE

func _ready() -> void:
	super()
	add_to_group("furnace")

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			_process_idle()
		State.PROCESSING:
			_process_processing()

func _process_idle() -> void:
	pass

func _process_processing() -> void:
	pass
