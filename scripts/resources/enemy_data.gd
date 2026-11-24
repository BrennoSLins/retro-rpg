extends Resource
class_name EnemyData

@export var name : String = "Enemy"
@export var sprite : Texture2D
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
