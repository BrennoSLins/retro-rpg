extends Control

# Data variable
@onready var dialog_list : Array[DialogData]

# Text & Image variables
@onready var image: TextureRect = $Image/TextureRect
@onready var speaker: Label = $Name
@onready var dialog: Label = $Dialog

# Index variable
@onready var cur_dialog_index = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	
	# Sets first speaker text & image
	speaker.text = dialog_list[cur_dialog_index]["speaker"]
	dialog.text = dialog_list[cur_dialog_index]["text"]
	image.texture = load(dialog_list[cur_dialog_index]["image"])

func _unhandled_input(event):
	if event.is_action_pressed("confirm"):
		advance_dialog()
		get_viewport().set_input_as_handled()

func advance_dialog():
	cur_dialog_index += 1
	
	# Advances the dialog, updating text & image
	if cur_dialog_index < dialog_list.size():
		speaker.text = dialog_list[cur_dialog_index]["speaker"]
		dialog.text = dialog_list[cur_dialog_index]["text"]
		image.texture = load(dialog_list[cur_dialog_index]["image"])
	else:
		# If dialog is over, end it all
		get_tree().paused = false
		queue_free()
	

func set_data(data: Array[DialogData]):
	dialog_list = data
