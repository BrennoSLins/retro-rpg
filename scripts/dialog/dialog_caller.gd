extends Node2D

@onready var interactable: Area2D = $Interactable
@export var data : Array[DialogData]

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	SignalBus.dialog_call.emit(data)
	
