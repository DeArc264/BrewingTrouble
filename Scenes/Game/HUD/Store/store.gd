extends Control

signal send(String, float)


var market_price = {
		# Bases
	"Water" : 2.0,
	"Milk" : 3.4,
	"Wine" : 6,
# Plants
	"Belladona" : 8.4,
	"Lavender" : 5.2,
	"Myrrh" : 7.8,
# Ores
	"Gold" : 1.0,
	"Sulfur" : 4.0
}

var current_price = {
		# Bases
	"Water" : 2.0,
	"Milk" : 3.4,
	"Wine" : 6,
# Plants
	"Belladona" : 8.4,
	"Lavender" : 5.2,
	"Myrrh" : 7.8,
# Ores
	"Gold" : 1.0,
	"Sulfur" : 4.0
}

var sale = " !!! SALE !!!"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_prices()
	write_labels($Bases)
	write_labels($Plants)
	write_labels($Ores)
	change_page("ToBases")


#region Prices
func set_prices():
	var temp

	for i in market_price:
		temp = randi_range(0,1)
		if temp == 1:
			current_price[i] = current_price[i] * 0.75


func write_labels(node : Node):
	for child in node.get_children():
		for children in child.get_children():
			if children is Label:
				if current_price[children.name] < market_price[children.name]:
					children.text = children.get_name() + " - " + str(current_price[children.get_name()]) + sale
				else:
					children.text = children.get_name() + " - " + str(current_price[children.get_name()])
#endregion


func change_page(button : String):
	match button:
		"ToBases":
			$Bases.show()
			$Plants.hide()
			$Ores.hide()
		"ToPlants":
			$Bases.hide()
			$Plants.show()
			$Ores.hide()
		"ToOres":
			$Bases.hide()
			$Plants.hide()
			$Ores.show()


func what_to_buy(ing : String):
	send.emit(ing, current_price[ing])


func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/Menu/menu.tscn")
