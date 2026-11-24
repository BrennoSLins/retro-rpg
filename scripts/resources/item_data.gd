extends Resource
class_name ItemData

@export var name : String = "Item"
@export_multiline var description : String = "ItemDescription"
@export var sprite : Texture2D
@export var itemtype: GameEnums.ItemType
@export var stats : GameEnums.CharacterStats
@export var value : int
@export var targettype : GameEnums.TargetType
