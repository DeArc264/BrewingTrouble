extends Control

signal get_ingredient (item : Item)
signal move_to_table
signal move_to_door

var ing_dict = {
# Bases
	"base_0" : 3,
	"base_1" : 3,
	"base_2" : 3,
# Plants
	"plant_0" : 5,
	"plant_1" : 5,
	"plant_2" : 5,
	"plant_3" : 5,
# Ores
	"ore_0" : 5,
	"ore_1" : 0,
# Flasks
	"flask_0" : 3,
	"flask_1" : 3,
	"flask_2" : 3
}


func _pick_up(ing : String):
	if ing_dict[ing] > 0:
		ing_dict[ing] -= 1
		get_ingredient.emit(load(Itens.ingredients[ing]).duplicate())
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
