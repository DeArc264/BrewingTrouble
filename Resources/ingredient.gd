extends Item
class_name Ingredient

@export var normal_icon : Texture2D
@export var crushed_icon : Texture2D
@export var dry_icon : Array[Texture2D]

@export_enum("Ore", "Plant", "Base")
var type = "Potion"

var conditions = []

var states = {
	"cut" : ["uncut", "thick", "medium", "thin"],
	"boil" : ["boiled", "hard boiled"],
	"dry" : ["half dry", "fully dry", "dehydrated"]
}

var cut_state = states["cut"][0]
var boil_state = states["boil"][0]
var dry_state = states["dry"][0]
var rank = 0


func change_icon(cond : String):
	var temp

	match cond:
		"crushed":
			icon = crushed_icon
		"dry":
			if dry_icon.has(icon):
				temp = dry_icon.find(icon) + 1
				if temp < dry_icon.size():
					icon = dry_icon[temp]
			else:
				icon = dry_icon[0]


func change_x_state(x : String):
	var cond_indx = 0
	var next_indx = 0
	var used_var

	match x:
		"cut":
			used_var = cut_state
		"boil":
			used_var = boil_state
		"dry":
			used_var = dry_state

	if conditions.has(used_var):
		cond_indx = conditions.find(used_var)
		next_indx = states[x].find(used_var) + 1

		if next_indx < states[x].size():
			used_var = states[x][next_indx]
			conditions.remove_at(cond_indx)
			conditions.append(used_var)
		else:
			conditions.append("useless")
	else:
		conditions.append(states[x][0])


func return_to_normal():
	icon = normal_icon
	cut_state = states["cut"][0]
	boil_state = states["boil"][0]
	dry_state = states["dry"][0]
	rank = 0
	conditions.clear()
