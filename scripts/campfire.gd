extends Node2D

@onready var interactable: Area2D = $Interactable


func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	SignalBus.call_upgrade_screen.emit(Player.party[0])
	
