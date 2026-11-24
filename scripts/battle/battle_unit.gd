extends Control

@onready var name_label: Label = $VBoxContainer/Name
@onready var texture: TextureRect = $VBoxContainer/UnitTexture
@onready var arrow_indicator: TextureRect = $VBoxContainer/ArrowIndicator
@onready var selectedskill : SkillData
@onready var health_bar: TextureProgressBar = $VBoxContainer/UnitTexture/HealthBar



# Button click signal
@warning_ignore('unused_signal')
signal on_selected(unit_instance)

# Health and mana track variables
var current_hp : int
var max_hp : int
var current_mp : int
var max_mp : int



# Player's data variable
var linked_status : Dictionary = {}

var unit_data : Resource #EnemyData or HeroData

func set_data(resource):
	unit_data = resource
	name_label.text = resource.name
	texture.texture = resource.sprite
	
	if unit_data is EnemyData:
		health_bar.visible = true
		health_bar.value = unit_data.basehp
		health_bar.max_value = unit_data.basehp
	


func _on_button_pressed() -> void:
	on_selected.emit(self)
	
func change_health(amount: int):
	current_hp += amount
	
	# Guarantees that HP wont go below 0 or above max
	if current_hp >= max_hp:
		current_hp = max_hp
	elif current_hp <= 0:
		current_hp = 0
	
	# Save hero data
	if unit_data is HeroData:
		if not linked_status.is_empty():
			linked_status["current_hp"] = current_hp
			SignalBus.update_player_stats.emit(linked_status, linked_status["data"]["name"])
	
	if unit_data is EnemyData:
		health_bar.value = current_hp
	
	# Hurt animation
	var tween = create_tween()
	tween.tween_property(texture, "modulate", Color(1,1,1,0.5), 0.1)
	tween.tween_property(texture, "modulate", Color(1,1,1,1), 0.1)
	

func change_mana(amount: int):
	current_mp += amount
	
	# Guarantees that MP wont go below 0 or above max
	if current_mp >= max_mp:
		current_mp = max_mp
	elif current_mp <= 0:
		current_mp = 0
	
	# Save hero data
	if unit_data is HeroData:
		if not linked_status.is_empty():
			linked_status["current_mp"] = current_mp
			SignalBus.update_player_stats.emit(linked_status, linked_status["data"]["name"])
