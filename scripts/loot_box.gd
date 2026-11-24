extends Node2D

@onready var interactable: Area2D = $Interactable
@export var loot_table : Array[ItemData]
var loot_dialog : Array[DialogData]



func _ready() -> void:
	interactable.interact = _on_interact
	loot_dialog.append(preload("uid://c2dlmwo0fflsg"))
	
func _on_interact():
	# Dialog for looted box
	if interactable.interact_name == "looted_box":
		loot_dialog[0].text = "Tá vazio."
		SignalBus.dialog_call.emit(loot_dialog)
		return
	
	
	# Selects item from loot table and appends to player
	var item_found = loot_table.pick_random()
	
	# Sets dialog text and emits signal
	loot_dialog[0].text = "Tinha um " + item_found.name + " aqui."
		
	# Calls dialog
	SignalBus.dialog_call.emit(loot_dialog)
	
	# Doesnt add to inventory if its trash
	if item_found.name == "Trash":
		#interactable.interact_name = "looted_box"
		return
	
	##interactable.interact_name = "looted_box"
	Player.inventory.append(item_found)
	
	
	
	
