extends Node

var map = {}

func _ready() -> void:
	map["Thruster"] = "res://Resources/Items/Thruster/ThrusterInventory.tres"
	map["Grabber"] = "res://Resources/Items/Grabber/GrabberInventory.tres"
	map["Furnace"] = "res://Resources/Items/Furnace/FurnaceInventory.tres"
	map["Inserter"] = "res://Resources/Items/Grabber/GrabberInventory.tres"
	map["Crate"] = "res://Resources/Items/Crate/crateinventory.tres"
	map["SmallGrabber"] = "res://Resources/Items/SmallGrabber/SmallGrabber.tres"
	map["SmallTurret"] = "res://Buildings/SmallTurret/SmallTurret.tres"
	map["MediumTurret"] = "res://Buildings/MediumTurret/MediumTurret.tres"
