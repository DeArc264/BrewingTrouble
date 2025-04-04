extends Control

signal cutted(Item)

var ing : Item
var cuts : int
var dirty = false

func start_cutting(item : Item):
	show()
	ing = item
	$ColorRect/Ingredient.set_texture(item.icon)
	cuts = 0


func _cut(area: Area2D) -> void:
	if area.name == "KnifeArea":
		cuts += 1
		if cuts >= 4:
			ing.change_x_state("cut")
			cuts = 0

#["Uncut", "Thick", "Medium", "Thin"]
func _on_end_button_pressed() -> void:
	cutted.emit(ing)
	hide()
