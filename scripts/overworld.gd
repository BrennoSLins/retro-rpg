extends Node2D

@export var overworld_audio : String
@export var combat_audio : String

@export_file_path var road: String
@export_file_path var back_ground: String
@export var spawn_point : Vector2

func _ready():
	AudioManager.is_combatbgm_playing.connect(manage_bgm)
	AudioManager.bgm_play.emit(overworld_audio)

func manage_bgm(condition: bool):
	if condition:
		AudioManager.bgm_play.emit(combat_audio)
	else:
		AudioManager.bgm_play.emit(overworld_audio)
