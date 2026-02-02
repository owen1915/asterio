extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var world: Node2D = $World
@onready var background: Node2D = $Background
@onready var player_inventory: PlayerInventory = $World/Player/Player_Inventory
@onready var hotbar: PanelContainer = $Menu/Hotbar
@onready var platform_layer: TileMapLayer = $World/platform_layer
@onready var building_layer_one: TileMapLayer = $World/building_layer_one

var debug = true

const PLATFORM_INVENTORY = preload("res://Resources/Items/Platform/PlatformInventory.tres")
const STONE_INVENTORY = preload("res://Resources/Items/Stone/StoneInventory.tres")
const THRUSTER_INVENTORY = preload("res://Resources/Items/Thruster/ThrusterInventory.tres")
const GRABBER_INVENTORY = preload("res://Resources/Items/Grabber/GrabberInventory.tres")
const INSERTER_INVENTORY = preload("res://Resources/Items/Inserter/InserterInventory.tres")
const CRATEINVENTORY = preload("res://Resources/Items/Crate/crateinventory.tres")
const FURNACE_INVENTORY = preload("res://Resources/Items/Furnace/FurnaceInventory.tres")
const SMALL_GRABBER = preload("res://Resources/Items/SmallGrabber/SmallGrabber.tres")
const MEDIUM_TURRET = preload("res://Buildings/MediumTurret/MediumTurret.tres")

func _ready() -> void:
	player_inventory.add(THRUSTER_INVENTORY, 99)
	player_inventory.add(PLATFORM_INVENTORY, 99)
	player_inventory.add(MEDIUM_TURRET, 99)
	player_inventory.add(INSERTER_INVENTORY, 99)
	player_inventory.add(CRATEINVENTORY, 99)
	player_inventory.add(FURNACE_INVENTORY, 99)
	player_inventory.add(SMALL_GRABBER, 99)
	player_inventory.add(GRABBER_INVENTORY, 99)
	player_inventory.add(STONE_INVENTORY, 99)

func _process(delta: float) -> void:
	#debug
	if debug:
		if Input.is_action_just_pressed("lmb"):
			var pos = building_layer_one.local_to_map(get_global_mouse_position())
			print(pos)
