extends Resource
class_name HeroData

@export_category("Informações")
@export var name : String = "Hero"
@export var sprite : Texture2D
@export var mugshot : Texture2D

@export_category("Atributos")
@export var basehp : float = 0
@export var basemp : float = 0
@export var attributes : Dictionary = {
	GameEnums.CharacterAttributes.STR : 0, # 0
	GameEnums.CharacterAttributes.DEF : 0, # 1
	GameEnums.CharacterAttributes.INT : 0, # 2
	GameEnums.CharacterAttributes.AGI : 0, # 3
	GameEnums.CharacterAttributes.CON : 0, # 4
	GameEnums.CharacterAttributes.DEX : 0 # 5
}
@export var skills : Array[SkillData] = []
@export var level : int = 1

var experience : int = 0
var available_stat_points : int = 0

var max_xp: int:
	get:
		return 50 * (level * 2)

func check_lvlup() -> bool:
	if experience >= max_xp:
		experience -= max_xp
		level += 1
		available_stat_points += 2
		return true
	else:
		return false


func change_attribute(att: GameEnums.CharacterAttributes, amount: int):
	attributes[att] += amount
