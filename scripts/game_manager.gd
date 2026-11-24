extends Node

#The Blueprints
@export var battle_scene : PackedScene
@export var selector_scene : PackedScene
@export var dialog_scene : PackedScene
@export var attribute_upgrade_scene: PackedScene

#The Container: where to put the scene
@onready var ui_layer: CanvasLayer = $"../UILayer"

@onready var worldNode: Node = %World


var road_path = preload("uid://bmsqu2fkyuoru")
var bg_path = preload("uid://bu60c31v2icxk")


func _ready():
	# We connect the signal to a func
	SignalBus.encounter_started.connect(start_battle)
	SignalBus.scenario_screen.connect(select_route)
	SignalBus.dialog_call.connect(dialog_show)
	SignalBus.update_world.connect(update_world_data)
	SignalBus.call_upgrade_screen.connect(attribute_upgrade_show)
	
	

func update_world_data(world: Dictionary):
	if world["combatroad"] is Object:
		road_path = world["combatroad"]
		
	if world["combatbg"] is Object:
		bg_path = world["combatbg"]
	
	print(road_path, bg_path)


func start_battle(enemy_data: Array[EnemyData]):
	# Pause the game
	get_tree().paused = true
	
	# Create battle scene (instantiate)
	var battle_instance = battle_scene.instantiate()
	
	# Add it to the screen. (Inside the CanvasLayer)
	ui_layer.add_child(battle_instance)
	
	# Makes an array of road and bg
	var road_bg : Array = [road_path, bg_path]
	# Pass the EnemyData and PlayerData to the Battle Scene
	battle_instance.initialize_combat(enemy_data, Player.party_status, road_bg)
	

func select_route():
	# Pause the game
	get_tree().paused = true
	
	# Create selector scene (instantiate)
	var selector_scene = selector_scene.instantiate()
	
	# Add it to the screen. (Inside the CanvasLayer)
	ui_layer.add_child(selector_scene)
	
	Player.visible = false
	

func dialog_show(data: Array[DialogData]):
	get_tree().paused = true
	
	# Create dialog box (instantiate)
	var dialog_box = dialog_scene.instantiate()
	
	# Passes data to scene
	dialog_box.set_data(data)
	
	# Add it to the screen. (Inside the CanvasLayer)
	ui_layer.add_child(dialog_box)

func attribute_upgrade_show(hero: HeroData):
	# Create selector scene (instantiate)
	var scene = attribute_upgrade_scene.instantiate()
	
	# Add it to the screen. (Inside the CanvasLayer)
	ui_layer.add_child(scene)
	
	# Passes data to scene
	scene.set_data(hero)
	
	Player.visible = false
	
	
