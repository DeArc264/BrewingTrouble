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
		"flask_0":
			icon = flaskA
		"flask_1":
			icon = flaskB
		"flask_2":
			icon = flaskC
