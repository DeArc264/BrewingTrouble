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
	"plant_0" : 3,
	"plant_1" : 0,
	"plant_2" : 3,
	"plant_3" : 3,
# Ores
	"ore_0" : 3,
	"ore_1" : 0,
# Flasks
	"flask_0" : 10,
	"flask_1" : 5,
	"flask_2" : 5
}


func _pick_up(ing : String):
	if ing_dict[ing] > 0:
		ing_dict[ing] -= 1
		get_ingredient.emit(load(Itens.ingredients[ing]).duplicate())
	else:
		$Flavor.text = "Oh... I don't have anymore of this"
		await get_tree().create_timer(2).timeout
		$Flavor.text = ""


func update_button(ing : String):
	var button

	match ing:
		"Water":
			button = $Water
		

	if ing_dict[ing] < 3:
		button.texture_normal = load(button.get_meta("half_icon"))


func add_stock_item(new : String):
	ing_dict[new] += 1


func _on_move_left_stock_pressed():
	move_to_door.emit()


func _on_move_right_stock_pressed():
	move_to_table.emit()
