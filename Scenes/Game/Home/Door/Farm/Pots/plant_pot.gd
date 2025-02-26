extends Control

signal harvest(item : Item)
signal can_in_area

@onready var slot = $Slot
@onready var harvest_button = $HarvestButton

var curr_seed = "none"

var how_wet = 0
var watering = false
var wasted = false

var time_left
var added_bonus
var wet_tween

var textures_plants = {
	"Lavander" : "res://Assets/Icons/missing.png",
	"Belladona" : ["res://Assets/Farm/Belladona/bella_small.png", "res://Assets/Farm/Belladona/bella_big.png", "res://Assets/Farm/Belladona/bella_dead.png"],
	"Ginger" : "res://Assets/Icons/missing.png",
	"Myrrth" : "res://Assets/Icons/missing.png",
	"Sage" : ["res://Assets/Farm/Sage/sage_small.png", "res://Assets/Farm/Sage/sage_big.png", "res://Assets/Farm/Sage/sage_dead.png"]
}


func _process(delta: float):
	if watering:
		how_wet += 30 * delta
		if how_wet == 100:
			adjust_pot_texture()

	clamp(how_wet, 0, 100)


func _on_slot_dropped() -> void:
	if slot.item is Seed:
		harvest_button.show()
		curr_seed = slot.item.type
		time_left = slot.item.grow_time
	elif slot.item is Ingredient and slot.item.type == "Plant":
		added_bonus += 1

		if added_bonus == 3:
			added_bonus = 0
			time_left = 1

	slot.empty()
	adjust_pot_texture()


func day_over():
	how_wet = 0

	if time_left >= 1:
		time_left -= 1

	$Slot3.item = load("res://Resources/Ingredients/Base/Water.tres")
	adjust_pot_texture()
	grow(curr_seed)


func grow(which : String):
	if wasted:
		harvest_button.texture_normal = load(textures_plants[which][2])
	else:
		if time_left > 0:
			harvest_button.texture_normal = load(textures_plants[which][0])
		else:
			harvest_button.disabled = false
			harvest_button.texture_normal = load(textures_plants[which][1])


func _on_harvest_button_pressed() -> void:
	if time_left <= 0:
		harvest_button.hide()
		harvest_button.disabled = true
		harvest.emit(Itens.ingredients[curr_seed])


func adjust_pot_texture():
	if how_wet == 0.0:
		if curr_seed != "none":
			self.texture = load("res://Assets/Farm/pot_dry.png")
		else:
			self.texture = load("res://Assets/Farm/pot_empty_dry.png")
	else:
		if curr_seed != "none":
			self.texture = load("res://Assets/Farm/pot_wet.png")
		else:
			self.texture = load("res://Assets/Farm/pot_empty_wet.png")


func water_the_plant(area: Area2D) -> void:
	if area.name == "WateringCan":
		watering = true
		can_in_area.emit()


func stop_water_the_plant(area: Area2D) -> void:
	if area.name == "WateringCan":
		watering = false
		can_in_area.emit()
