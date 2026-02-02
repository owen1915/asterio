extends Node
@onready var menu: CanvasLayer = $"../Menu"

var speed = 0 # speed in kilometers
var thrusters_on = false

func _ready() -> void:
	update()

func update():
	menu.ship_panel.speed_label.text = str(snapped(speed, 0.01)) + "km/s"

func toggle_thrusters():
	thrusters_on = !thrusters_on
	if thrusters_on:
		for thruster in get_tree().get_nodes_in_group("thrusters"):
			thruster.turn_on()
	else:
		for thruster in get_tree().get_nodes_in_group("thrusters"):
			thruster.turn_off()
