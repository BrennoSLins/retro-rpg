extends Control
@onready var name_desc: Label = $VBoxContainer/NameDesc
@onready var image: TextureRect = $VBoxContainer/Image
var scenario_data : Dictionary
@onready var selected_color: ColorRect = $SelectedColor


func set_data(scenario: Dictionary):
	name_desc.text = scenario["name"] + "\n" + scenario["description"]
	image.texture = scenario["image"]
	scenario_data = scenario
	SignalBus.scenario_selected.connect(check_press)

func _on_button_pressed() -> void:
	# Emit signal on selected route, sends data
	selected_color.visible = true
	SignalBus.scenario_selected.emit(scenario_data)

func check_press(data: Dictionary):
	if data != scenario_data:
		selected_color.visible = false
