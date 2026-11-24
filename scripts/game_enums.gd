extends Node

# Enums
enum TargetType {
	SINGLE_ENEMY,
	ALL_ENEMIES,
	SINGLE_ALLY,
	ALL_ALLIES,
	SELF
}

enum ItemType {
	FOOD_ITEM,
	COMBAT_ITEM,
	KEY_ITEM,
	CRAFTING_MATERIAL,
}

enum CharacterStats {
	HP,
	MP
}
enum CharacterAttributes {
	STR, # 0
	DEF, # 1
	INT, # 2
	AGI, # 3
	CON, # 4
	DEX # 5
}
