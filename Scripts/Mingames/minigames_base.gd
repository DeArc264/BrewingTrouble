extends Control
class_name Minigame

signal modified_ing(Item)

@export var dirt : Area2D
@export var element : Area2D
@export var slot : Slot

var dirty = false
var progress = 0.0
var progress_speed
var level = 0
var current_ing : Item

func show_on_screen():
	if dirty:
		dirt.get_parent().modulate = 1
	else:
		dirt.get_parent().modulate = 0

	show()


func start_minigame():
	if slot.item is Ingredient:
		current_ing = slot.item
		element.get_parent().texture = current_ing.icon
		element.monitoring = true

	elif slot.item.id == "tool_0":
		dirt.monitoring = true


func increase_progress():
	progress += 0.1


func rub_rag(event : InputEvent):
	if event is InputEventMouseMotion:
		if progress < 1.0:
			dirt.modulate.a += 0.1

			if $Dirt.modulate == 1.0:
				dirty = false
				end_minigame()


func end_minigame():
	hide()
	element.monitoring = false
	dirt.monitoring = false

	if current_ing:
		modified_ing.emit(current_ing)
