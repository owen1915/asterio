class_name DefaultBuilding extends Building

func can_place() -> bool:
	var area = get_area()
	
	if building_layer_one.has_platform(area):
		return super()
	return false
