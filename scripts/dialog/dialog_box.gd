extends Control

# Data variable
@onready var dialog_list : Array[DialogData]

# Text & Image variables
@onready var image: TextureRect = $Image/TextureRect
@onready var speaker: Label = $Name
@onready var dialog: Label = $Dialog

# Choices button variables
@onready var button: Button = $Choices/Button
@onready var button2: Button = $Choices/Button2
@onready var button3: Button = $Choices/Button3

# Index variable
@onready var cur_dialog_index = 0
var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	update_dialog()
	await get_tree().create_timer(0.5).timeout
	is_ready = true
	

func _unhandled_input(event):
	if event.is_action_pressed("confirm") and is_ready:
		advance_dialog()
		get_viewport().set_input_as_handled()

func advance_dialog():
	if dialog_list[cur_dialog_index].is_choice:
		return
	
	cur_dialog_index += 1
	
	# Advances the dialog, updating text & image
	if cur_dialog_index < dialog_list.size():
		update_dialog()
	else:
		# If dialog is over, end it all
		get_tree().paused = false
		queue_free()
	

func set_data(data: Array[DialogData]):
	dialog_list = data
	
func update_dialog():
	var current_dialog = dialog_list[cur_dialog_index]
	
	speaker.text = current_dialog.speaker
	dialog.text = current_dialog.text
	
	image.texture = load(current_dialog.image)
	# Checks for choices
	button.visible = current_dialog.is_choice
	button2.visible = current_dialog.is_choice
	button3.visible = current_dialog.is_choice
	
	if current_dialog.is_choice:
		button.text = current_dialog.choices[0]
		button2.text = current_dialog.choices[1]
		button3.text = current_dialog.choices[2]
		

func _on_button_pressed() -> void:
	dialog_list = dialog_list[cur_dialog_index].response1
	cur_dialog_index = -1
	advance_dialog()

func _on_button_2_pressed() -> void:
	dialog_list = dialog_list[cur_dialog_index].response2
	cur_dialog_index = -1
	advance_dialog()

func _on_button_3_pressed() -> void:
	dialog_list = dialog_list[cur_dialog_index].response3
	cur_dialog_index = -1
	advance_dialog()
