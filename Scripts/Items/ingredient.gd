extends Item
class_name Ingredient

@export var normal_icon : Texture2D
@export var crush_icon : Array[Texture2D]
@export var cut_icon : Array[Texture2D]
@export var dry_icon : Array[Texture2D]

@export_enum("Ore", "Plant", "Base")
var type = "Base"

var conditions = []

var states = {
	"crush" : ["uncrushed", "thick powder", "medium powder", "thin powder"],
	"cut" : ["uncut", "thick slice", "medium slice", "thin slice"],
	"boil" : ["boiled", "hard boiled"],
	"dry" : ["half dry", "fully dry", "dehydrated"]
}

var crush_state = states["crush"][0]
var cut_state = states["cut"][0]
var boil_state = states["boil"][0]
var dry_state = states["dry"][0]
var rank = 0


func change_icon(cond : String):
	var temp_arr
	var temp_index

	match cond:
		"crush":
			temp_arr = crush_icon
		"cut":
			temp_arr = cut_icon
		"dry":
			temp_arr = dry_icon

	if temp_arr.has(icon):
		temp_index = temp_arr.find(icon) + 1
		if temp_index < temp_arr.size():
			icon = temp_arr[temp_index]
	else:
		icon = temp_arr[0]


func change_x_state(x : String):
	var cond_indx = 0
	var next_indx = 0
	var used_var

	match x:
		"crush":
			used_var = crush_state
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
