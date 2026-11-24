extends Control

# Local variables
@onready var hname: Label = $Name
@onready var hp_numbers: Label = $HPNumbers
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var mp_numbers: Label = $MPNumbers
@onready var mp_bar: TextureProgressBar = $MPBar

var localname : String
var current_hp : int
var max_hp : int
var current_mp : int
var max_mp : int

# Update signal
func _ready() -> void:
	SignalBus.update_player_stats.connect(update_data)


func set_data(status: Dictionary):
	# Sets name
	hname.text = status["data"]["name"]
	localname = status["data"]["name"]
	
	# Sets variables for hp_numbers
	current_hp = status["current_hp"]
	max_hp = status["max_hp"]
	
	hp_numbers.text = "HP : " + str(current_hp) + " / " + str(max_hp)
	
	# Sets hp_bar values
	hp_bar.value = current_hp
	hp_bar.max_value = max_hp
	
	# Sets variables for mp_numbers
	current_mp = status["current_mp"]
	max_mp = status["max_mp"]
	
	mp_numbers.text = "MP : " + str(current_mp) + " / " + str(max_mp)
	
	# Sets mp_bar values
	mp_bar.value = current_mp
	mp_bar.max_value = max_mp

func update_data(status: Dictionary, sname: String):
	if sname == localname:
		# Sets variables for hp_numbers
		current_hp = status["current_hp"]
		max_hp = status["max_hp"]
		
		if current_hp <= 0:
			hp_numbers.text = "HP : " + str(0) + " / " + str(max_hp)
		else:
			hp_numbers.text = "HP : " + str(current_hp) + " / " + str(max_hp)
		
		# Sets hp_bar values
		hp_bar.value = current_hp
		hp_bar.max_value = max_hp
		
		# Sets variables for mp_numbers
		current_mp = status["current_mp"]
		max_mp = status["max_mp"]
		
		if current_mp <= 0:
			mp_numbers.text = "MP : " + str(0) + " / " + str(max_mp)
		else:
			mp_numbers.text = "MP : " + str(current_mp) + " / " + str(max_mp)
		
		# Sets mp_bar values
		mp_bar.value = current_mp
		mp_bar.max_value = max_mp
