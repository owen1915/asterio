extends Node

func _input(event: InputEvent):
	if event.is_action_pressed("debug_scale_up"):
		# Double the window size
		get_window().set_size(get_window().size * 2)
	
	if event.is_action_pressed("debug_fullscreen"):
		# Or toggle fullscreen
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
