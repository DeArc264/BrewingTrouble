extends Control
class_name Minigame

signal modified_ing(Item)

@export var dirt : TextureRect
@export var element : TextureRect

var dirty = false
var progress = 1.0
var progress_speed
var level = 0
var current_ing : Item

func show_on_screen():
	if dirty:
		dirt.modulate = 1
	else:
		dirt.modulate = 0

	show()


func start_minigame(new_ing : Item):
	if new_ing is Ingredient:
		current_ing = new_ing
		element.texture = current_ing.icon
		element.monitoring = true

	elif new_ing.id == "tool_0":
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
