extends Item
class_name Potion

@export var recipe : Array[Item]

@export var flaskA : Texture2D
@export var flaskB : Texture2D
@export var flaskC : Texture2D

@export_enum("Wasted", "Normal", "Perfect")
var state = "Normal"

func fill_potion(flask : String):
	match flask:
		"Empty A":
			icon = flaskA
		"Empty B":
			icon = flaskB
		"Empty C":
			icon = flaskC
