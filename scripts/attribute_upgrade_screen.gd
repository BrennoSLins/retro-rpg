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
	character_image.texture = herodata.mugshot
	character_name.text = herodata.name
	level.text = str(herodata.level)
	
	str_actual.text = str(herodata.attributes[0])
	def_actual.text = str(herodata.attributes[1])
	int_actual.text = str(herodata.attributes[2])
	agi_actual.text = str(herodata.attributes[3])
	con_actual.text = str(herodata.attributes[4])
	dex_actual.text = str(herodata.attributes[5])
	available_label.text = str(available_points)
	
	var lvlup : bool = herodata.check_lvlup()
	
	hero = herodata
	
	# May break!!!!!
	if lvlup:
		available_points += 2
		set_data(herodata)
	



func _on_increase_butt_pressed(button: BaseButton) -> void:
	print(button.name + " reacted")
	var is_increase = button.name.ends_with("IncreaseButt")
	var attribute = button.name.left(3)
	
	if available_points <= 0:
		return
	
	print(button.name + " has available points")
	
	if not is_increase:
		return
	
	print(button.name + " is increase")
	
	match attribute:
		"Str":
			hero.attributes[0] += 1
			str_actual.text = str(hero.attributes[0])
			alloted_points += 1
			available_points -=1
			str_plus_var += 1
			str_plus.text = "+" + str(str_plus_var)
			available_label.text = str(available_points)
		"Def":
			hero.attributes[1] += 1
			def_actual.text = str(hero.attributes[1])
			alloted_points += 1
			available_points -=1
			def_plus_var += 1
			def_plus.text = "+" + str(def_plus_var)
			available_label.text = str(available_points)
		"Int":
			hero.attributes[2] += 1
			int_actual.text = str(hero.attributes[2])
			alloted_points += 1
			available_points -=1
			int_plus_var += 1
			int_plus.text = "+" + str(int_plus_var)
			available_label.text = str(available_points)
		"Agi":
			hero.attributes[3] += 1
			agi_actual.text = str(hero.attributes[3])
			alloted_points += 1
			available_points -=1
			agi_plus_var += 1
			agi_plus.text = "+" + str(agi_plus_var)
			available_label.text = str(available_points)
		"Con":
			hero.attributes[4] += 1
			con_actual.text = str(hero.attributes[4])
			alloted_points += 1
			available_points -=1
			con_plus_var += 1
			con_plus.text = "+" + str(con_plus_var)
			available_label.text = str(available_points)
		"Dex":
			hero.attributes[5] += 1
			dex_actual.text = str(hero.attributes[5])
			alloted_points += 1
			available_points -=1
			dex_plus_var += 1
			dex_plus.text = "+" + str(dex_plus_var)
			available_label.text = str(available_points)


func _on_decrease_butt_pressed(button: BaseButton) -> void:
	print(button.name + " reacted")
	var is_increase = button.name.ends_with("IncreaseButt")
	var attribute = button.name.left(3)
	
	if alloted_points <= 0:
		return
	
	print(button.name + " has alloted_points")
	if is_increase:
		return
		
	
	print(button.name + " is not increase")
	match attribute:
		"Str":
			hero.attributes[0] -= 1
			str_actual.text = str(hero.attributes[0])
			alloted_points -= 1
			available_points +=1
			str_plus_var -= 1
			str_plus.text = "+" + str(str_plus_var)
			available_label.text = str(available_points)
		"Def":
			hero.attributes[1] -= 1
			def_actual.text = str(hero.attributes[1])
			alloted_points -= 1
			available_points +=1
			def_plus_var -= 1
			def_plus.text = "+" + str(def_plus_var)
			available_label.text = str(available_points)
		"Int":
			hero.attributes[2] -= 1
			int_actual.text = str(hero.attributes[2])
			alloted_points -= 1
			available_points +=1
			int_plus_var -= 1
			int_plus.text = "+" + str(int_plus_var)
			available_label.text = str(available_points)
		"Agi":
			hero.attributes[3] -= 1
			agi_actual.text = str(hero.attributes[3])
			alloted_points -= 1
			available_points +=1
			agi_plus_var -= 1
			agi_plus.text = "+" + str(agi_plus_var)
			available_label.text = str(available_points)
		"Con":
			hero.attributes[4] -= 1
			con_actual.text = str(hero.attributes[4])
			alloted_points -= 1
			available_points +=1
			con_plus_var -= 1
			con_plus.text = "+" + str(con_plus_var)
			available_label.text = str(available_points)
		"Dex":
			hero.attributes[5] -= 1
			dex_actual.text = str(hero.attributes[5])
			alloted_points -= 1
			available_points +=1
			dex_plus_var -= 1
			dex_plus.text = "+" + str(dex_plus_var)
			available_label.text = str(available_points)
	
	print(button.name + " has concluded")

func _on_confirm_pressed() -> void:
	Player.visible_switch(true)
	self.queue_free()


func _on_cancel_pressed() -> void:
	pass # Replace with function body.
