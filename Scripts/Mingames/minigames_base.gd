extends Control
class_name Minigame

signal modified_ing(Item)

@export var dirt : Area2D
@export var element : Area2D
@export var slot : Slot
@export var end_button : Button

var start_dict = {
	"plant_0" : load("res://Assets/Minigames/belladona_0.png"),
	"plant_1" : load("res://Assets/Minigames/ginger_0.png"),
	"plant_2" : load("res://Assets/Minigames/lavander_0.png"),
	"plant_3" : load("res://Assets/Minigames/berries_0.png")
}

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
	if slot.item == null: return

	if slot.item is Ingredient:
		current_ing = slot.item
		element.get_parent().texture = start_dict[current_ing.id]
		element.monitoring = true
		end_button.show()

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


func change_icon(arr : Array):
	var current_texture = element.get_parent().texture

	if arr.has(current_texture):
		var next_index = arr.find(current_texture) + 1
		element.get_parent().texture = arr[next_index]
	else:
		element.get_parent().texture = arr[0]


func end_minigame():
	hide()
	element.monitoring = false
	dirt.monitoring = false
	end_button.hide()

	if current_ing:
		modified_ing.emit(current_ing)
