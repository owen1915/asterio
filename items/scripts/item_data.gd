class_name ItemData
extends Resource

@export var item_name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
@export var max_stack: int = 99
@export var buildable = false
@export var scene: PackedScene
