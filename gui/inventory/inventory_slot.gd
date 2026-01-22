extends Control

var empty = true
var item_data : ItemData
@onready var parent: GridContainer = $".."
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var correct_pos = null

enum State {RELAXED, MOVING}
var state = State.RELAXED
var target = null

func _process(delta: float) -> void:
	match state:
		State.RELAXED:
			pass
		State.MOVING:
			_process_moving()

func _process_moving() -> void:
	if Input.is_action_pressed("placed"):
		global_position = get_global_mouse_position()
		get_button_in_pos()
	else:
		if target == null:
			global_position = correct_pos
		else:
			var temp_texture = texture_rect.texture
			var temp_label = label.text
			var temp_item_data = item_data
			
			item_data = target.item_data
			label.text = target.label.text
			texture_rect.texture = target.texture_rect.texture
			
			target.item_data = temp_item_data
			target.label.text = temp_label
			target.texture_rect.texture = temp_texture
			target = null
			global_position = correct_pos
		state = State.RELAXED

func get_button_in_pos() -> void:
	for c in parent.get_children():
		if c != self and c.get_global_rect().has_point(get_global_mouse_position()):
			target = c
			return
	target = null

func _on_toggled(toggled_on: bool) -> void:
	"""if (toggled_on):
		if parent.swap == null:
			parent.swap = self
		else:
			var temp_texture = texture_rect.texture
			var temp_label = label
			var temp_item_data = item_data
			
			item_data = parent.swap.item_data
			label = parent.swap.label
			texture_rect.texture = parent.swap.texture_rect.texture
			
			parent.swap.item_data = temp_item_data
			parent.swap.label = temp_label
			parent.swap.texture_rect.texture = temp_texture
			
			parent.swap = null
	"""
	pass


func _on_pressed() -> void:
	focus_mode = Control.FOCUS_NONE
	correct_pos = global_position
	state = State.MOVING
