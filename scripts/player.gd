extends CharacterBody2D

@export var SPEED : float = 80.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var party : Array[HeroData]

var hp: int
var party_status : Array = []
var inventory : Array[ItemData] = []
var gold : int = 0

var can_move : bool = true

func _ready():
	#Appends Rapheal
	party.append(preload("uid://yljkm2ht7y8w"))
	#Appends Zagreus
	party.append(preload("uid://res50yns2mc7"))
	#Appends Linky
	party.append(preload("uid://csg83k2bqwaot"))
	
	# Connect player visibility signal to function
	SignalBus.player_visibility.connect(visible_switch)
	SignalBus.player_teleport.connect(teleport_player)
	
	#Loop through and build active party
	for hero in party:
		#Creates dictionary to track real-time stats
		var status = {
			"data": hero,
			"max_hp": hero.basehp,
			"current_hp": hero.basehp,
			"max_mp": hero.basemp,
			"current_mp": hero.basemp,
			"skills": hero.skills,
			
		}
		
		party_status.append(status)


func _physics_process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_move:
		var direction := Input.get_vector("moveleft", "moveright", "moveup", "movedown")
		velocity = direction * SPEED
	
	move_and_slide()

func visible_switch(switch: bool):
	match switch:
		true:
			self.visible = true
		false:
			self.visible = false

func teleport_player(coords: Vector2):
	self.global_position = coords
