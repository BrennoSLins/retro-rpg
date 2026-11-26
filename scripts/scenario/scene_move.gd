extends Node2D

@export var scene : PackedScene
@export var spawn : Vector2

@onready var interactable: Area2D = $Interactable
@onready var world: Node = $"../../../World"

func _ready() -> void:
	interactable.interact = _on_interact
	SignalBus.scenario_confirmed.connect(route_confirmed)
	

func _on_interact():
	# Checks if its a door or a route selection caller
	if interactable.interact_name == "select_route":
		SignalBus.scenario_screen.emit()
		return
	
	# Get children of current world and clears them 1 by 1
	for child in world.get_children():
		child.queue_free()
	
	# Instantiates new world and adds as a child
	var new_world = scene.instantiate()
	world.add_child(new_world)
	
	# Teleports player to map spawn vector
	Player.global_position = spawn

func route_confirmed(data: Dictionary):
	var newscene = data["scene"]
	var newspawn = data["spawn"] 
	
	# Get children of current world and clears them 1 by 1
	for child in world.get_children():
		child.queue_free()
	
	# Instantiates new world and adds as a child
	var new_world = newscene.instantiate()
	world.add_child(new_world)
	
	# Teleports player to map spawn vector
	SignalBus.player_teleport.emit(newspawn)
