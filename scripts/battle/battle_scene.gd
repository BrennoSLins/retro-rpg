extends Control

# Background control
@onready var back_ground: TextureRect = $BattleLayout/BackGround
@onready var road: TextureRect = $Road


# Blueprint
@export var battle_unit_scene : PackedScene
@export var party_info_scene : PackedScene
@export var skill_info_scene : PackedScene

# Lists (who is alive)
var active_hero_units : Array = []
var active_enemy_units : Array = []

var current_hero_index : int = 0
var is_targeting : bool = false


# Buttons
@onready var attack_button: Button = $"ButtonsContainer/Action buttons/AttackButton"
@onready var run_button: Button = $"ButtonsContainer/Action buttons/RunButton"
@onready var guard_button: Button = $"ButtonsContainer/Action buttons/GuardButton"
@onready var focus_button: Button = $"ButtonsContainer/Action buttons/FocusButton"
@onready var item_button: Button = $"ButtonsContainer/Action buttons/ItemButton"


# Layout
@onready var main_text: Label = $TextContainer/MainText
@onready var player_container: HBoxContainer = $BattleLayout/BattleArea/PlayerContainer
@onready var enemy_container: HBoxContainer = $BattleLayout/BattleArea/EnemyContainer

@onready var info_panel: PanelContainer = $PartyInfoContainer
@onready var action_info_panel: PanelContainer = $ActionInfoContainer

@onready var info_container: VBoxContainer = $PartyInfoContainer/VBoxContainer
@onready var action_info_container: VBoxContainer = $ActionInfoContainer/VBoxContainer


func initialize_combat(enemy_data: Array, party_status: Array, road_map: Array):
	# Sets combat BG
	print(road_map[0], road_map[1])
	print(Player)
	road.texture = road_map[0]
	back_ground.texture = road_map[1]
	
	# Spawn enemies loop (create unit from blueprint)
	for enemy in enemy_data:
		var unit = battle_unit_scene.instantiate()
		
		# Add to screen
		enemy_container.add_child(unit)
		
		# Setup data
		unit.set_data(enemy)
		
		# Update actual health
		unit.current_hp = enemy.basehp
		unit.max_hp = enemy.basehp
		
		
		# Makes arrow invisible
		unit.arrow_indicator.self_modulate = Color(255, 0, 0, 0)
		
		# Connect click signal
		unit.on_selected.connect(_on_enemy_selected)
		
		# Add to active list
		active_enemy_units.append(unit)
	
	# Spawn party loop
	for hero in party_status:
		# Dead check
		if hero["current_hp"] <= 0:
			continue #skips and goes to the next hero
			
		var unit = battle_unit_scene.instantiate()
		
		player_container.add_child(unit)
		
		# Acessing and setting data from dictionary
		unit.set_data(hero["data"])
		
		# Update actual health
		unit.current_hp = hero["current_hp"]
		unit.max_hp = hero["max_hp"]
		
		# Update actual mp
		unit.current_mp = hero["current_mp"]
		unit.max_mp = hero["max_mp"]
		
		# Data link
		unit.linked_status = hero
		
		# Connect click signal
		unit.on_selected.connect(_on_hero_selected)
		
		# Flip texture and makes arrow invisible
		unit.texture.flip_h = false
		unit.arrow_indicator.self_modulate = Color(0, 0, 0, 0)
		
		
		# Append
		active_hero_units.append(unit)
		
		# Handles info container
		var infobar = party_info_scene.instantiate()
		
		info_container.add_child(infobar)
		
		infobar.set_data(hero)
		
		
	# End of loop
	start_player_turn()
	
	

func start_player_turn():
	# Check if all heroes moved
	if current_hero_index >= active_hero_units.size():
		enemy_phase() # All heroes acted
		return
	
	# Check if enemies are alive
	if active_enemy_units.size() <= 0:
		win_battle()
		return
	
	# Reset UI
	attack_button.disabled = false
	is_targeting = false
	guard_button.disabled = false
	focus_button.disabled = false
	item_button.disabled = false
	run_button.disabled = false
	main_text.text = "It's " + active_hero_units[current_hero_index].unit_data.name + "'s turn!"
	active_hero_units[current_hero_index].arrow_indicator.self_modulate = Color(1, 1, 1, 1)
	

##################################  Button handles #####################################

# Attack handles
func _on_attack_button_pressed() -> void:
	# Disables party info and enables action info
	info_panel.visible = false
	action_info_panel.visible = true
	
	# Instantiates skills in info container
	for skill in active_hero_units[current_hero_index].unit_data.skills:
		var skillinfo = skill_info_scene.instantiate()
		
		# Add to screen
		action_info_container.add_child(skillinfo)
		
		# Setup data
		skillinfo.set_data(skill)
		
		# Connect click signal
		skillinfo.on_selected.connect(_on_skill_selected)
		
	
	#Lock buttons
	attack_button.disabled = true
	run_button.disabled = true
	guard_button.disabled = true
	focus_button.disabled = true
	item_button.disabled = true


func _on_skill_selected(skill_data: SkillData):
	active_hero_units[current_hero_index].selected_action = skill_data
	is_targeting = true
	main_text.text = "Using " + skill_data.name + ". Select target"
	

func _on_hero_selected(hero_unit):
	if is_targeting:
		if not active_hero_units[current_hero_index].selected_action.target_type == 2:
			return
			
		is_targeting = false
		
	# Resets action info container to party info
	for child in action_info_container.get_children():
		child.queue_free()
		
	info_panel.visible = true
	action_info_panel.visible = false
		
	# Who is healing
	var healer = active_hero_units[current_hero_index]
	var healerskill = active_hero_units[current_hero_index].selectedskill
	
	# Consume mana
	healer.change_mana(-healerskill.mp_cost)
	
	# Heal value
	var heal = damage_formula(healer.unit_data, hero_unit.unit_data, healerskill)
	hero_unit.change_health(heal)
	
	main_text.text = healer.unit_data.name + " heals for " + str(heal) + "!"
	await get_tree().create_timer(0.5).timeout
	
	# Check & removes if dead
	if hero_unit.current_hp <= 0:
		active_hero_units.erase(hero_unit)
		hero_unit.queue_free()
	
	await get_tree().create_timer(1.0).timeout
	
	# Check win
	if active_enemy_units.size() <= 0:
		win_battle()
	else:
		active_hero_units[current_hero_index].arrow_indicator.self_modulate = Color(1, 1, 1, 0)
		current_hero_index += 1
		start_player_turn()


func _on_enemy_selected(enemy_unit):
	if is_targeting:
		is_targeting = false
		
		# Resets action info container to party info
		for child in action_info_container.get_children():
			child.queue_free()
		
		info_panel.visible = true
		action_info_panel.visible = false
		
		if active_hero_units[current_hero_index].selected_action is SkillData:
			# Who is attacking
			var attacker = active_hero_units[current_hero_index]
			var attackerskill = active_hero_units[current_hero_index].selected_action
	
			# Consume mana
			attacker.change_mana(-attackerskill.mp_cost)
		
			# Deal damage
			var damage = damage_formula(attacker.unit_data, enemy_unit.unit_data, attackerskill)
			enemy_unit.change_health(-damage)
		
			main_text.text = attacker.unit_data.name + " attacks for " + str(damage) + " damage!"
			await get_tree().create_timer(0.5).timeout
		
		elif active_hero_units[current_hero_index].selected_action is ItemData:
			var attackeritem = active_hero_units[current_hero_index].selected_action
			enemy_unit.change_health(-attackeritem.value)
			main_text.text = attackeritem.name + " causes " + str(attackeritem.value) + " damage!"
		
		# Check and removes
		if enemy_unit.current_hp <= 0:
			active_enemy_units.erase(enemy_unit)
			enemy_unit.queue_free()
		
		await get_tree().create_timer(1.0).timeout
		
		# Check win
		if active_enemy_units.size() <= 0:
			win_battle()
		else:
			active_hero_units[current_hero_index].arrow_indicator.self_modulate = Color(1, 1, 1, 0)
			current_hero_index += 1
			start_player_turn()

# End of attack handles

func _on_run_button_pressed() -> void:
	AudioManager.is_combatbgm_playing.emit(false)
	get_tree().paused = false
	queue_free()

func _on_guard_button_pressed() -> void:
	active_hero_units[current_hero_index].arrow_indicator.self_modulate = Color(1, 1, 1, 0)
	
	current_hero_index += 1
	start_player_turn()

func _on_focus_button_pressed() -> void:
	active_hero_units[current_hero_index].arrow_indicator.self_modulate = Color(1, 1, 1, 0)
	active_hero_units[current_hero_index].change_mana(+3)
	current_hero_index += 1
	start_player_turn()

# Item handles
func _on_item_button_pressed() -> void:
	# Disables party info and enables action info
	info_panel.visible = false
	action_info_panel.visible = true
	
	if Player.inventory.size() == 0:
		main_text.text = "Você não tem itens!"
		await get_tree().create_timer(1.5).timeout
		start_player_turn()
		info_panel.visible = true
		action_info_panel.visible = false
		return
	
	# Instantiates skills in info container
	for item in Player.inventory:
		var iteminfo = skill_info_scene.instantiate()
		
		# Add to screen
		action_info_container.add_child(iteminfo)
		
		# Setup data
		iteminfo.set_data(item)
		
		# Connect click signal
		iteminfo.on_selected.connect(_on_item_selected)
		
	
	#Lock buttons
	attack_button.disabled = true
	run_button.disabled = true
	guard_button.disabled = true
	focus_button.disabled = true
	item_button.disabled = true

func _on_item_selected(item_data: ItemData):
	# Resets action info container to party info
	for child in action_info_container.get_children():
		child.queue_free()
		
	info_panel.visible = true
	action_info_panel.visible = false
	
	match item_data.targettype:
		0: #Single enemy
			active_hero_units[current_hero_index].selected_action = item_data
			is_targeting = true
			main_text.text = "Using " + item_data.name + ". Select target"
			return
		
		1: #All enemies
			for enemy in active_enemy_units.duplicate():
				enemy.change_health(-item_data.value)
				
				# Check and removes
				if enemy.current_hp <= 0:
					active_enemy_units.erase(enemy)
					enemy.queue_free()
				
			
			main_text.text = active_hero_units[current_hero_index].unit_data.name + " usou " + item_data.name + "!"
			await get_tree().create_timer(2.0).timeout
			
			Player.inventory.erase(item_data)
			
			end_heroturn()
			
		2: #Single ally
			pass
		3: #All allies
			pass
		4: #Self
			match item_data.stats:
				0:# HP
					active_hero_units[current_hero_index].change_health(item_data.value)
					
				1:# MP
					active_hero_units[current_hero_index].change_mana(item_data.value)
			main_text.text = active_hero_units[current_hero_index].unit_data.name + " usou " + item_data.name + "!"
			await get_tree().create_timer(1.0).timeout
			
			end_heroturn()
			
	
	


func enemy_phase():
	# Lock buttons
	attack_button.disabled = true
	run_button.disabled = true
	guard_button.disabled = true
	focus_button.disabled = true
	item_button.disabled = true
	
	main_text.text = "Its their turn."
	await get_tree().create_timer(1.0).timeout
	
	# Enemy loop
	for enemy in active_enemy_units:
		# Arrow indicator
		enemy.arrow_indicator.self_modulate = Color(255, 0, 0, 1)
		
		# Dead check
		if active_hero_units.size() == 0: break
		
		# Pick target
		var target = active_hero_units.pick_random()
		
		# Pick skill
		var selectedskill = enemy.unit_data.skills.pick_random()
		
		# Attack
		var finaldmg = damage_formula(enemy.unit_data, target.unit_data, selectedskill)
		target.change_health(-finaldmg)
		main_text.text = enemy.unit_data.name + " attacks " + target.unit_data.name + " for " + str(finaldmg) + " damage!"
		await get_tree().create_timer(1.0).timeout
		
		# Check player death
		if target.current_hp <= 0:
			active_hero_units.erase(target)
		
		enemy.arrow_indicator.self_modulate = Color(255, 0, 0, 0)
	# End of loop
	
	current_hero_index = 0
	if active_hero_units.size() > 0:
		start_player_turn()
	else: 
		game_over()

func win_battle():
	main_text.text = "You mogged them!"
	await get_tree().create_timer(2.0).timeout
	
	AudioManager.is_combatbgm_playing.emit(false)
	get_tree().paused = false
	queue_free()

func game_over():
	main_text.text = "You got mogged!"
	await get_tree().create_timer(2.0).timeout
	
	get_tree().paused = false
	get_tree().reload_current_scene()

func damage_formula(attacker: Resource, victim: Resource, skill: SkillData):
	# Gets skill damage
	var skilldmg = skill.calculate_damage(attacker)
		
	var victim_def = victim.attributes[1]
	
	var finaldmg = skilldmg - victim_def
	
	if finaldmg < 0:
		finaldmg = 0
	
	return finaldmg
	
func end_heroturn():
	active_hero_units[current_hero_index].arrow_indicator.self_modulate = Color(1, 1, 1, 0)
	current_hero_index += 1
	start_player_turn()
