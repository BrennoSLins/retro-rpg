extends Control

@export var route_card : PackedScene
@onready var world: Node = $"../../World"
@onready var confirm_button: Button = $ConfirmButton
@onready var selected_route: Dictionary

@onready var route_cards_box: HBoxContainer = $MainLayout/RouteCards
var scene1 = SignalBus.get_scenario_by_id("c1_huntingseason")
var scene2 = SignalBus.get_scenario_by_id("c1_sticky")
var scene3 = SignalBus.get_scenario_by_id("c1_beemayhem")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connects signal to function
	SignalBus.scenario_selected.connect(set_scenario)
	
	
	# Instantiates cards, adds to screen, sets data
	var scenarios = [scene1, scene2, scene3]
	for scenario in scenarios:
		var card = route_card.instantiate()
		route_cards_box.add_child(card)
		card.set_data(scenario)
	
	# Makes current world invisible
	for child in world.get_children():
		child.visible = false
	


func set_scenario(scenario_data: Dictionary):
	selected_route = scenario_data

func _on_confirm_button_pressed() -> void:
	
	SignalBus.scenario_confirmed.emit(selected_route)
	
	# Deletes selector
	self.queue_free()
	
	SignalBus.player_visibility.emit(true)
	SignalBus.update_world.emit(selected_route)
	
	get_tree().paused = false
