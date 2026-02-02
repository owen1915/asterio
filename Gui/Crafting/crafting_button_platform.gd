extends CraftingButton

const PLATFORM_INVENTORY = preload("res://Resources/Items/Platform/PlatformInventory.tres")

func _on_pressed() -> void:
	craft_item(PLATFORM_INVENTORY)
