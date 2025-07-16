extends Resource
class_name Item

@export var icon : Texture2D
@export var name : String
@export var id : String

@export_multiline var description : String

@export_enum("Ore", "Plant", "Base", "Flask", "Tool")
var type = "Base"
