extends Resource
class_name SkillData

@export var name : String = "SkillName"
@export_multiline var description : String = "SkillDescription"
@export var sprite : Texture2D
@export var dmg_multiplier : float = 1.2
@export var mp_cost : int = 0
@export var main_attribute : GameEnums.CharacterAttributes
@export var target_type : GameEnums.TargetType

func calculate_damage(attacker_data: Resource):
	var statvalue: int = attacker_data.attributes[main_attribute]
	var damage = statvalue * dmg_multiplier
	return int(damage)
	
	
