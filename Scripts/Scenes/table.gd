extends Control

signal new_item(item : Item) # Signal to add a new item to player hand
signal helper(which : String)

# Mobility(206-213) signals
signal move_to_stock
signal move_to_door


#region Variables
@onready var caldron_slot = $CaldronSlot # Slot for adding ingredients
@onready var embers = $CaldronImg/Embers

@export var craftables : Array[Item] # Array of possible crafts

var in_caldron = [null] # Current in the mixture(112-192)
var boiling = false # Boiling(42-69) state
var holder

var ing_conditions = {
	"potion_1" : {
		"plant_0" : [],
		"plant_3" : []
	},
	"potion_2" : {
		"plant_2" : ["crushed"],
		"plant_3" : ["crushed"]
	},
	"potion_3" : {
		"plant_0" : ["crushed"],
		"plant_2" : ["fully dry"]
	}
}
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
# Controls the timer for drying(71-77) based on having an item in the drying
#slot and the item not being already dry
	if boiling:
		$ING1BoilTimer.paused = false
		$ING2BoilTimer.paused = false
		$Bubbling.play()
	else:
		$ING1BoilTimer.paused = true
		$ING2BoilTimer.paused = true

# Boiling control
#region Boil
# Function for bellows. If there is a base liquid, it boils. If it was already
# boiling, it restarts the timer for boiling.
func _on_bellows_pressed() -> void:
	$Bellows.play("default")
	$Fire.play()
	embers.play("lit_up")

	await embers.animation_finished

	if in_caldron[0] != null and in_caldron[0].type == "Base":
		embers.play("loop")
		if boiling:
			$BoilTimer.start(11)
		else:
			await get_tree().create_timer(2).timeout
			boiling = true
			$BoilTimer.start(11)
		$Smoke.play("start")
		await $Smoke.animation_finished
		$Smoke.play("loop")
	else:
		embers.play("dying")
		await embers.animation_finished
		embers.play("default")

		$DryNet.can_dry = true
		$ING1BoilTimer.paused = false
		$ING2BoilTimer.paused = false

# Ends boiling state when timer runs out.
func _on_boil_timer_timeout() -> void:
	boiling = false
	$BoilLabel.hide()
	$DryNet.can_dry = false
	$ING1BoilTimer.paused = true
	$ING2BoilTimer.paused = true

# Boil control for ingredient at position 1 in "in_caldron" array.
func ing_1_boil_round():
	if in_caldron[1] != null:
		in_caldron[1].change_x_state("boil")
	else:
		$ING1BoilTimer.stop()

# Boil control for ingredient at position 2 in "in_caldron" array.
func ing_2_boil_round():
	if in_caldron[2] != null:
		in_caldron[2].change_x_state("boil")
	else:
		$ING2BoilTimer.stop()
#endregion


func _on_board_clicked():
	$Cutter.show_on_screen()


func _on_mortar_clicked() -> void:
	$Mortar.show_on_screen()

# Distill control
#region Distillary
# Checks if the item dropped can be distilled based on it's type
func _on_distillery_slot_dropped() -> void:
	if $DistillerySlot.item.type == "Plant":
		$Fire.play()
		$DistilTimer.start()

# Timer for distilling
func _on_distil_timer_timeout() -> void:
	if $DistillerySlot.item != null:
		$DistillerySlot.item.conditions.append("distilled")
#endregion

func update_item(new : Item):
	new_item.emit(new)

# Mixing and crafting control
#region Mixing
# Checks the item dropped into the caldron. If it's a type "Base", it is assigned
# to the first index. If not, it is appended to the "in_caldron" array.
func _on_caldron_slot_dropped() -> void:
	if $CaldronSlot.item.name == "Rag":
		pass
	else:
		if $CaldronSlot.item.get_script().get_global_name() == "Ingredient":
			if caldron_slot.item.type == "Base":
				in_caldron[0] = caldron_slot.item
			else:
				in_caldron.append(caldron_slot.item)
		else:
			in_caldron.append(caldron_slot.item)

		if in_caldron.size() == 2 and in_caldron[1] != null:
			$ING1BoilTimer.start()
		if in_caldron.size() == 3 and in_caldron[2] != null:
			$ING2BoilTimer.start()

		caldron_slot.empty()

		if in_caldron.size() >= 3:
			mix()


func mix() -> void:
	if in_caldron.size() >= 3 and in_caldron[0] != null:
		$CaldronSlot.hide()
		$FlaskSlot.show()
		$ING1BoilTimer.stop()
		$ING2BoilTimer.stop()
		$Caldron.start_minigame(in_caldron[0].id, check_recipe())

# Uses the elements inside "in_caldron" to see which recipe is being followed
func check_recipe():
	if in_caldron.size() > 3:
		return "potion_0"

	for i in in_caldron:
		if i == Potion or i.conditions.has("useless") or i == null:
			return "potion_0"

	for p in craftables.size():
		if is_in_recipe(p):
			if recipe_conditions(craftables[p].id):
				return craftables[p].id
			else:
				return "potion_0"


# Get's every item in "in_caldron", then compares to every element of a specific
# recipe. If all items match, no matter the order, returns true to indicate
# this is the correct recipe
func is_in_recipe(recipe : int):
	var aligned_array = []

	for i in craftables[recipe].recipe:
		if i not in in_caldron:
			return false
		else:
			aligned_array.append(i)

	in_caldron = aligned_array
	return true


# Checks the variables of the items in "in_caldron". If they match all the
# conditions, the potion is correctly crafted
func recipe_conditions(recipe : String):
	if in_caldron[1].conditions == ing_conditions[recipe][in_caldron[1].id]:
		if in_caldron[2].conditions == ing_conditions[recipe][in_caldron[2].id]:
			return true

	return false

# Once mixed, uses "check_recipe" function to decide which potion was crafted
func _on_caldron_mixed(potion_id : String) -> void:
	var potion = load(Itens.potions[potion_id])

	if in_caldron[0].rank + in_caldron[1].rank + in_caldron[2].rank > 3:
		potion.state = "Perfect"
	
	await $FlaskSlot.dropped
	potion.fill_potion(in_caldron.back().id)
	new_item.emit(potion)

	in_caldron.clear()
	in_caldron = [null]
	$CaldronSlot.show()
	$FlaskSlot.hide()
#endregion

# Table hourglass control
#region Hourglass
func _on_turn_hourglass_pressed() -> void:
	$Hourglass.play("turn")
	await $Hourglass.animation_finished
	$HourglassTimer.start()
	$Hourglass.play("run")
#endregion

# Mobility
#region Move
func _on_move_left_table_pressed() -> void:
	move_to_stock.emit()


func _on_move_right_table_pressed() -> void:
	move_to_door.emit()
#endregion


func _on_book_button_pressed() -> void:
	$Book.show()


#region Helpers
func show_help(which : String):
	helper.emit(which)


func hide_help():
	helper.emit("close")
#endregion
