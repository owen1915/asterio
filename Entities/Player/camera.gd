extends Camera2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in") and zoom < Vector2.ONE * 4:
		zoom += Vector2.ONE
	
	if Input.is_action_just_pressed("zoom_out") and zoom > Vector2.ONE * 2:
		zoom -= Vector2.ONE
