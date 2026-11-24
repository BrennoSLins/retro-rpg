extends Control

@onready var skill_image: TextureRect = $HBoxContainer/SkillImage
@onready var skill_name: Label = $HBoxContainer/SkillName
@onready var skill_description: Label = $HBoxContainer/SkillDescription
@onready var skill_cost: Label = $HBoxContainer/SkillCost
@onready var skill_data


@onready var button: Button = $Button


# Signal
@warning_ignore('unused_signal')
signal on_selected(skill_instance)

func _on_button_pressed() -> void:
	on_selected.emit(skill_data)

func set_data(data):
	if data is SkillData:
		skill_image.texture = data.sprite
		skill_description.text = data.description
		skill_name.text = data.name
		skill_cost.text = "COST: " + str(data.mp_cost)
		skill_data = data
	
	elif data is ItemData:
		skill_image.texture = data.sprite
		skill_description.text = data.description
		var attribute_name = GameEnums.CharacterValues.keys()[data.attribute]
		skill_name.text = data.name
		skill_cost.text = "EFFECT: " + attribute_name + " " + str(data.value)
		skill_data = data
