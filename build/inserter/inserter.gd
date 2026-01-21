extends Building

enum State {IDLE, GET, DELIVER}
var state = State.IDLE

func _ready() -> void:
	super()
	add_to_group("inserters")

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			_process_idle()
		State.GET:
			_process_get()
		State.DELIVER:
			_process_deliver()

func _process_idle() -> void:
	pass

func _process_get() -> void:
	pass

func _process_deliver() -> void:
	pass
