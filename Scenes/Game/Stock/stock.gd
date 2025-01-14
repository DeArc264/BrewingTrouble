extends Control

signal get_ingredient (item : Item)
signal move_to_table
signal move_to_door

var hands_full = false

var inst_dict = {
	# Bases
	"Water" : "res://Resources/Ingredients/Base/Water.tres",
	"Milk" : "res://Resources/Ingredients/Base/Milk.tres",
	"Wine" : "res://Resources/Ingredients/Base/Wine.tres",
# Plants
	"Belladona" : "res://Resources/Ingredients/Plant/Belladona.tres",
	"Lavender" : "res://Resources/Ingredients/Plant/Lavander.tres",
	"Myrrh" : "res://Resources/Ingredients/Plant/Myrrh.tres",
# Ores
	"Gold" : "res://Resources/Ingredients/Ore/Gold.tres",
	"Sulfur" : "res://Resources/Ingredients/Ore/Sulfur.tres",
# Flasks
	"A" : "res://Resources/Ingredients/Flasks/Empty_Flask_A.tres",
	"B" : "res://Resources/Ingredients/Flasks/Empty_Flask_B.tres",
	"C" : "res://Resources/Ingredients/Flasks/Empty_Flask_C.tres"
}

var ing_dict = {
# Bases
	"Water" : 3,
	"Milk" : 3,
	"Wine" : 3,
# Plants
	"Belladona" : 5,
	"Lavender" : 5,
	"Myrrh" : 5,
# Ores
	"Gold" : 5,
	"Sulfur" : 0,
# Flasks
	"A" : 3,
	"B" : 3,
	"C" : 3
}


func _pick_up(ing : String):
	if not hands_full:
		if ing_dict[ing] > 0:
			ing_dict[ing] -= 1
			get_ingredient.emit(load(inst_dict[ing]))
		else:
			$Flavor.text = "Oh... I don't have any " + ing
			await get_tree().create_timer(2).timeout
			$Flavor.text = "My stock"


func add_stock_item(new : String):
	ing_dict[new] += 1


func _on_move_left_stock_pressed():
	move_to_door.emit()


func _on_move_right_stock_pressed():
	move_to_table.emit()
