extends Resource
class_name DialogData

@export var speaker: String
@export_multiline var text: String
@export_file var image : String

@export_group("Choice Menu")
@export var is_choice : bool
@export var choices : Array[String] = []
@export_subgroup("Responses")
@export var response1 : Array[DialogData] = []
@export var response2 : Array[DialogData] = []
@export var response3 : Array[DialogData] = []
