extends Control



#region Variables
@onready var caldron_slot = $CaldronTexture/CaldronInvetory/CaldronSlot

var ING1 : Item
var ING2 : Item

var boiling = false
var drying = false
var currDryTime = 10.0
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Dryer.item != null and $Dryer.item.dry == false:
		if boiling:
			if not drying:
				currDryTime = 10.0
				start_drying()
		else:
			stop_drying()

	if boiling:
		$BoilLabel.show()
	else:
		$BoilLabel.hide()

	$BoilLabel.text = "Boiling... " + str(int($BoilTimer.time_left))
	$DryLabel.text = "Drying..." + str(int($DryTimer.time_left))

#region Boil
func _on_bellows_pressed() -> void:
	if boiling:
		$BoilTimer.start(6)
	else:
		await get_tree().create_timer(2).timeout
		boiling = true
		$BoilTimer.start(6)


func _on_boil_timer_timeout() -> void:
	boiling = false
#endregion

#region Drying
func start_drying():
	$DryTimer.start(currDryTime)
	drying = true

func stop_drying():
	currDryTime = float($DryTimer.time_left)
	$DryTimer.stop()

func _on_dry_timer_timeout() -> void:
	$DryLabel.show()
	$Dryer.item.dry = true
	await get_tree().create_timer(2).timeout
#endregion

#region Mortar
func _on_mortar_slot_dropped() -> void:
	if not $MortarSlot.item.crushed:
		$Mortar.show()


func _on_mortar_crushed_ingredient() -> void:
	$MortarSlot.item.crushed = true


func _on_mortar_ruined_ingredient() -> void:
	$MortarSlot.item.useless = true
#endregion

#region Mixing
func _on_caldron_slot_dropped() -> void:
	if ING1 == null:
		ING1 = caldron_slot.item
		$CaldronTexture/CaldronInvetory.remove_item(caldron_slot.item)
	elif ING2 == null:
		ING2 = caldron_slot.item
		$CaldronTexture/CaldronInvetory.remove_item(caldron_slot.item)
	else:
		$CaldronTexture/CaldronInvetory.remove_item(caldron_slot.item)


func _on_mix_pressed() -> void:
	$Caldron.show()


func _on_caldron_mixed() -> void:
	if ING1 != null and ING2 != null:
		$Hands.add_item(load("res://Resources/Potions/PotionStrenght.tres"))
#endregion
