extends Item
class_name Ingredient

@export var normal_icon : Texture2D
@export var crush_icon : Texture2D
@export var cut_icon : Texture2D
@export var dry_icon : Texture2D

@export_enum("Ore", "Plant", "Base")
var type = "Base"

var conditions = []

var rank = 0
