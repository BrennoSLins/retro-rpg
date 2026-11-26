extends Control

# Character container variables
@onready var character_image: TextureRect = $Panel/MainContainer/CharacterContainer/CharacterImage
@onready var character_name: Label = $Panel/MainContainer/CharacterContainer/CharacterInfoContainer/Name
@onready var level: Label = $Panel/MainContainer/CharacterContainer/CharacterInfoContainer/Level
@onready var available_label: Label = $Panel/MainContainer/CharacterContainer/CharacterInfoContainer/AvailablePts

#### Attributes containers values ####
# Strength
@onready var str_actual: Label = $Panel/MainContainer/AttributesContainer/StrContainer/ActualValue
@onready var str_plus: Label = $Panel/MainContainer/AttributesContainer/StrContainer/PlusValue
var str_plus_var : int

# Defense
@onready var def_actual: Label = $Panel/MainContainer/AttributesContainer/DefContainer/ActualValue
@onready var def_plus: Label = $Panel/MainContainer/AttributesContainer/DefContainer/PlusValue
var def_plus_var : int

# Intelligence
@onready var int_actual: Label = $Panel/MainContainer/AttributesContainer/IntContainer/ActualValue
@onready var int_plus: Label = $Panel/MainContainer/AttributesContainer/IntContainer/PlusValue
var int_plus_var : int

# Agility
@onready var agi_actual: Label = $Panel/MainContainer/AttributesContainer/AgiContainer/ActualValue
@onready var agi_plus: Label = $Panel/MainContainer/AttributesContainer/AgiContainer/PlusValue
var agi_plus_var : int

# Constitution
@onready var con_actual: Label = $Panel/MainContainer/AttributesContainer/ConContainer/ActualValue
@onready var con_plus: Label = $Panel/MainContainer/AttributesContainer/ConContainer/PlusValue
var con_plus_var : int

# Dexterity
@onready var dex_actual: Label = $Panel/MainContainer/AttributesContainer/DexContainer/ActualValue
@onready var dex_plus: Label = $Panel/MainContainer/AttributesContainer/DexContainer/PlusValue
var dex_plus_var : int

#### Variables ####
var available_points : int = 0
var alloted_points : int

var hero: HeroData
var temp_hero: HeroData

# Confirm/Cancel buttons
@onready var confirm: Button = $Panel/MainContainer/AttributesContainer/ConfirmCancelContainer/Confirm
@onready var cancel: Button = $Panel/MainContainer/AttributesContainer/ConfirmCancelContainer/Cancel


func _ready() -> void:
	for attribute_container in $Panel/MainContainer/AttributesContainer.get_children():
		
		for child in attribute_container.get_children():
	
			if child is BaseButton and child.name.ends_with("IncreaseButt"):
				child.pressed.connect(_on_increase_butt_pressed.bind(child))
				print("connected" + child.name)
			elif child is BaseButton and child.name.ends_with("DecreaseButt"):
				child.pressed.connect(_on_decrease_butt_pressed.bind(child))
				print("connected" + child.name)

func set_data(herodata: HeroData):
	# Sets hero and temporary hero data
	hero = herodata
	available_points = hero.available_stat_points
	temp_hero = herodata.duplicate(true)
	
	# Sets name, lvl, mugshot and available points
	character_image.texture = herodata.mugshot
	character_name.text = herodata.name
	level.text = str(herodata.level)
	available_points = herodata.available_stat_points
	available_label.text = "Available Points : " + str(available_points)
	
	# Current attribute index
	var current_att = 0
	
	# Attributes values set loop
	for attribute in herodata.attributes:
		var att_initials = GameEnums.CharacterAttributes.keys()[current_att].left(3).to_lower()
		print(att_initials)
		var node = get(att_initials + "_actual")
		node.text = str(herodata.attributes[current_att])
		
		current_att = (current_att + 1) % GameEnums.CharacterAttributes.size()
	
	var lvlup : bool = herodata.check_lvlup()
	
	
	
	if lvlup:
		set_data(herodata)
	



func _on_increase_butt_pressed(button: BaseButton) -> void:
	# Identifies increase button and attribute
	var is_increase = button.name.ends_with("IncreaseButt")
	var att_initials = button.name.left(3).to_upper()
	var att_index = GameEnums.CharacterAttributes.keys().find(att_initials)
	
	# Label nodes variables
	var node_actual = get(att_initials.to_lower() + "_actual")
	var node_plus = get(att_initials.to_lower() + "_plus")
	var plus_var = get(att_initials.to_lower() + "_plus_var")
	print (plus_var)
	
	
	# Checks for available points
	if available_points <= 0:
		return
	
	# Ends if its decrease button
	if not is_increase:
		return
	
	# Up attributes
	temp_hero.attributes[att_index] += 1
	
	# Changes text to new value
	node_actual.text = str(temp_hero.attributes[att_index])
	
	# Changes alloted and available points
	alloted_points += 1
	available_points -= 1
	
	# May be the issue!
	set(att_initials.to_lower() + "_plus_var", plus_var + 1)
	
	# Sets plus text to plus variable
	node_plus.text = "+" + str(get(att_initials.to_lower() + "_plus_var"))
	
	# Sets available text to available variable
	available_label.text = "Available Points : " + str(available_points)
	

func _on_decrease_butt_pressed(button: BaseButton) -> void:
	# Identifies increase button and attribute
	var is_increase = button.name.ends_with("IncreaseButt")
	var att_initials = button.name.left(3).to_upper()
	var att_index = GameEnums.CharacterAttributes.keys().find(att_initials)
	print(att_index)
	
	# Label nodes variables
	var node_actual = get(att_initials.to_lower() + "_actual")
	var node_plus = get(att_initials.to_lower() + "_plus")
	var plus_var = get(att_initials.to_lower() + "_plus_var")
	
	
	# Checks
	if alloted_points <= 0:
		return
	
	if is_increase:
		return
		
	if int(node_actual.text) == hero.attributes[att_index]:
		return
	
	# Changes attribute value and label
	temp_hero.attributes[att_index] -= 1
	node_actual.text = str(temp_hero.attributes[att_index])
	
	# Changes local variables
	alloted_points -= 1
	available_points += 1
	
	# Deduces from plus variable and sets labels
	set(att_initials.to_lower() + "_plus_var", plus_var - 1)
	node_plus.text = "+" + str(get(att_initials.to_lower() + "_plus_var"))
	available_label.text = "Available Points : " + str(available_points)
	
	

func _on_confirm_pressed() -> void:
	temp_hero.available_stat_points = available_points
	Player.party[0] = temp_hero
	
	Player.visible = true
	self.queue_free()


func _on_cancel_pressed() -> void:
	pass # Replace with function body.
