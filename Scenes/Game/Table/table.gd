extends Control

signal new_item(item : Item) # Signal to add a new item to player hand
signal crush(item : Item)
# Mobility(206-213) signals
signal move_to_stock
signal move_to_door


#region Variables
@onready var caldron_slot = $CaldronSlot # Slot for adding ingredients

@export var craftables : Array[Item] # Array of possible crafts


var in_caldron = [null] # Current in the mixture(112-192)
var boiling = false # Boiling(42-69) state
var holder

var ing_conditions = {
	"Strenght Potion" : {
		"Belladona" : ["crushed", "boiled"],
		"Lavander" : ["fully dry"]
	},
	
	"Stamina Potion" : {
		"Lavander" : ["crushed", "distilled"],
		"Myrrh" : ["crushed"]
	},
	"Healing Potion" : {
		"Belladona" : [],
		"Myrrh" : []
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
		$DryTimer.paused = false
	else:
		$ING1BoilTimer.paused = true
		$ING2BoilTimer.paused = true
		$DryTimer.paused = true

# Updates texts. Remove later
	$BoilLabel.text = "Boiling... " + str(int($BoilTimer.time_left))
	$DryLabel.text = "Drying..." + str(int($DryTimer.time_left))
	$HourglassLabel.text = str(int($HourglassTimer.time_left))
	$Label.text = "Ing 1: " + str($ING1BoilTimer.time_left) + "\nIng2: " + str($ING2BoilTimer.time_left)

# Boiling control
#region Boil
# Function for bellows. If there is a base liquid, it boils. If it was already
# boiling, it restarts the timer for boiling.
func _on_bellows_pressed() -> void:
	if in_caldron[0] != null and in_caldron[0].type == "Base":
		if boiling:
			$BoilTimer.start(11)
		else:
			await get_tree().create_timer(2).timeout
			boiling = true
			$BoilTimer.start(11)

		$BoilLabel.show()
		$DryTimer.paused = false
		$ING1BoilTimer.paused = false
		$ING2BoilTimer.paused = false

# Ends boiling state when timer runs out.
func _on_boil_timer_timeout() -> void:
	boiling = false
	$BoilLabel.hide()
	$DryTimer.paused = true
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

# Drying control
#region Drying
func _on_dryer_dropped() -> void:
	$DryTimer.start()
	$DryLabel.show()


# When the timer runs out, the item in the slot is considered "dry"
func _on_dry_timer_timeout() -> void:
	if $Dryer.item != null:
		if not $Dryer.item.conditions.has("useless"):
			$Dryer.item.change_x_state("dry")
			$Dryer.item.change_icon("dry")
			$Dryer.item = $Dryer.item
			$DryTimer.start()
		else:
			await get_tree().create_timer(2.0).timeout
			$DryLabel.hide()
#endregion

# Cutting control
#region Cut
func _on_cutter_slot_dropped():
	$CutterSlot.empty()
	#if $CutterSlot.item.type == "Plant":
		#$Cutter.start_cutting($CutterSlot.item)
	#else:
		#$Cutter.dirty = true


func update_cut(new : Item):
	$CutterSlot.empty()
	$CutterSlot.item = new
#endregion

# Crushing control
#region Mortar
# Checks if an item was dropped, if it is not already crushed and if it can be crushed
func _on_mortar_slot_dropped() -> void:
	crush.emit($MortarSlot.item)


func update_crush(new : Item):
	$MortarSlot.empty()
	$MortarSlot.item = new
#endregion

# Distill control
#region Distillary
# Checks if the item dropped can be distilled based on it's type
func _on_distillery_slot_dropped() -> void:
	if $DistillerySlot.item.type == "Plant":
		$DistilTimer.start()

# Timer for distilling
func _on_distil_timer_timeout() -> void:
	if $DistillerySlot.item != null:
		$DistillerySlot.item.conditions.append("distilled")
#endregion

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

# When the button is pressed, checks if there are enough ingredients and shows
# the caldron minigame.
func _on_mix_pressed() -> void:
	if in_caldron.size() >= 3 and in_caldron[0] != null:
		$ING1BoilTimer.stop()
		$ING2BoilTimer.stop()
		$Caldron.show()

# Uses the elements inside "in_caldron" to see which recipe is being followed
func check_recipe():
	if in_caldron.size() > 3:
		return 9

	for i in in_caldron:
		if i.conditions.has("useless"):
			return 9

	for j in craftables.size():
		if is_in_recipe(j):
			if recipe_conditions(craftables[j].name):
				return j
			else:
				return 9


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
	if in_caldron[1].conditions == ing_conditions[recipe][in_caldron[1].name]:
		if in_caldron[2].conditions == ing_conditions[recipe][in_caldron[2].name]:
			return true

	return false


# Once mixed, uses "check_recipe" function to decide which potion was crafted
func _on_caldron_mixed() -> void:
	var potion

	match check_recipe():
		0:
			potion = craftables[0]
		1:
			potion = craftables[1]
		2:
			potion = craftables[2]
		_:
			potion = load("res://Resources/Potions/WeirdPotion.tres")

	if in_caldron[0].rank + in_caldron[1].rank + in_caldron[2].rank > 3:
		potion.state = "Perfect"
	
	await $CaldronSlot.dropped
	potion.fill_potion(in_caldron.back().name)
	new_item.emit(potion)

	in_caldron[1].return_to_normal()
	in_caldron[2].return_to_normal()

	in_caldron.clear()
	in_caldron = [null]
#endregion

# Table hourglass control
#region Hourglass
func _on_turn_hourglass_pressed() -> void:
	$HourglassTimer.start()
	$HourglassLabel.show()


func _on_hourglass_timer_timeout() -> void:
	$HourglassLabel.hide()
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
