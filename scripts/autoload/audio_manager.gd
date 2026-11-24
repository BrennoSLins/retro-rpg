extends Node

# Signals
signal bgm_play(tname: String)
signal sfx_play(tname: String)

@warning_ignore('unused_signal')
signal is_combatbgm_playing(condition: bool)

# Variables
var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var current_combat : String
var current_overworld : String

var sfx_list : Dictionary = {}
var bgm_list : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Loads audio files
	load_audio("res://sounds/sfx/", sfx_list)
	load_audio("res://sounds/bgm/", bgm_list)
	
	# Connects signals
	bgm_play.connect(play_bgm)
	sfx_play.connect(play_sfx)
	
	# Creates nodes
	create_audio_players()

func create_audio_players():
	# BGM Player
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGMPlayer"
	bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(bgm_player)

	# SFX Players
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sfx_player)


func play_sfx(sound_name: String):
	if sound_name == "stopaudio":
		sfx_player.stop()
	
	if sfx_list.has(sound_name):
		sfx_player.stream = sfx_list[sound_name]
		sfx_player.play()


func play_bgm(music_name: String):
	if music_name == "_stopaudio":
		sfx_player.stop()
	
	
	if bgm_list.has(music_name):
		bgm_player.stream = bgm_list[music_name]
		bgm_player.play()

func load_audio(path: String, target_dict: Dictionary):
	var files = DirAccess.get_files_at(path)
	
	for file_name in files:
		var full_path = path.path_join(file_name)
		
		# Ignora arquivos que não são de áudio
		if not file_name.get_extension() in ["wav", "ogg", "mp3", "ogg.import"]:
			continue
		
		var audio = load(full_path)
		
		if audio is AudioStream:
			var audio_name = file_name.get_basename()
			target_dict[audio_name] = audio
		
			print("Carregado: ", audio_name)

#OLD: func load_audio(path: String, target_dict: Dictionary):
	#var dir = DirAccess.open(path)
	 #
	#if dir == null:
		#printerr("Não foi possível acessar: ", path)
		#return
#
	#dir.list_dir_begin()
#
	#var file_name = dir.get_next()
#
	#while file_name != "":
		#if not dir.current_is_dir():
			#var full_path = path + file_name
			#var audio = load(full_path)
			#
			#if audio is AudioStream:
				#var audio_name = file_name.get_basename()
				#target_dict[audio_name] = audio
	#
	#file_name = dir.get_next()
	#
	#dir.list_dir_end()
