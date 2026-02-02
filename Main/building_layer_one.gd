extends TileMapLayer

@onready var platform_layer: TileMapLayer = $"../platform_layer"

var building_choords = {}

func _ready() -> void:
	for c in get_children():
		c.add_building()

func _process(delta: float) -> void:
	pass

func has_platform(area) -> bool:
	for positions in area:
		if positions not in platform_layer.platforms:
			return false
	
	return true

func has_no_platform(area) -> bool:
	for positions in area:
		if positions in platform_layer.platforms:
			return false
	
	return true
