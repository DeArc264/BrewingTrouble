extends Control

signal get_ingredient (item : Item)
signal move_to_table
signal move_to_door

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
	if ing_dict[ing] > 0:
		ing_dict[ing] -= 1
		$PickUp.play()
		get_ingredient.emit(load(Itens.ingredients[ing]))
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
