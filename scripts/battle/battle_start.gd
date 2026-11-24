extends Node2D

@onready var interactable: Area2D = $Interactable
@export var enemy_data : Array[EnemyData]


func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	interactable.is_interactable = false
	AudioManager.is_combatbgm_playing.emit(true)
	SignalBus.encounter_started.emit(enemy_data)
	self.queue_free()
