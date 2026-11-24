extends Node

# Signals
@warning_ignore('unused_signal')
signal encounter_started(enemy_data)

@warning_ignore('unused_signal')
signal encounter_ended()

@warning_ignore('unused_signal')
signal update_world(world_data: Dictionary)

@warning_ignore('unused_signal')
signal scenario_selected(scenario_data)

@warning_ignore('unused_signal')
signal scenario_screen()

@warning_ignore('unused_signal')
signal scenario_confirmed(scenario_data)

@warning_ignore('unused_signal')
signal player_visibility(switch: bool)

@warning_ignore('unused_signal')
signal player_teleport(coords: Vector2)

@warning_ignore('unused_signal')
signal dialog_call(data: Array[DialogData])

@warning_ignore('unused_signal')
signal update_player_stats(hero: Dictionary)

@warning_ignore('unused_signal')
signal call_upgrade_screen(hero: HeroData)

# Player node
var player : CharacterBody2D

func register_player(player_node: CharacterBody2D) -> void:
	player = player_node

# Global funcs
func get_scenario_by_id(id: String):
	for scenario in scenarios:
		if scenario["id"] == id:
			return scenario

	return null

func RollDice(sides: int):
	var result : int = randi_range(1,sides)
	return result

# Scenarios Dictionary
var scenarios = [
	{
		"id": "c1_huntingseason",
		"name": "Hunting Season",
		"description": "Join the ongoing hunt for Boars",
		"scene": preload("res://scenes/maps/open_forest.tscn"),
		"image": preload("uid://jw5u3dl61ltx"),
		"combatroad": "",
		"combatbg": "",
		"spawn" : ""
	},
	{
		"id": "c1_sticky",
		"name": "Sticky Situation",
		"description": "Defeat the horde of Slimes and clean the caves.",
		"scene": "",
		"image": preload("uid://decjvprr4tm06"),
		"combatroad": preload("uid://dlukvep7f5y1m"),
		"combatbg": preload("uid://jvlggkhjmodw"),
		"spawn" : Vector2(95,232)
	},
	{
		"id": "c1_beemayhem",
		"name": "Beekeeping Mayhem",
		"description": "Protect the Beehive from the Wasps.",
		"scene": preload("res://scenes/maps/bee_farm.tscn"),
		"image": preload("uid://bboiw1wy0jnpu"),
		"combatroad": "",
		"combatbg": "",
		"spawn" : ""
	}
]
