extends Control

#region Variables and Signals
signal move_to_table
signal move_to_stock
signal day_start
signal pay (int)
signal order(String)
signal helper(which : String)

@export var orders : Array[Item]
@onready var dia = load("res://Resources/Dialogue/NPCDialogues.tres")

var curr_order = []
var client_at_door = false
var delivery : Array[Item]
#endregion

func _process(_delta: float) -> void:
	if not $DoorWindow.visible:
		$PatienceTimer.paused = false
		$CheckDoor.disabled = false
		$ClientLabel.hide()
	else:
		$PatienceTimer.paused = true
		$CheckDoor.disabled = true
		$ClientLabel.show()


func new_request():
	var temp = randi_range(1, 3)

	if not client_at_door:
		$Knock.play()
		client_at_door = true
		$PatienceTimer.start(120)
		for i in temp:
			curr_order.append((orders.pick_random()).name)

		$ClientLabel.text = dia.phrase_constructor(curr_order)


func deliver():
	if not client_at_door:
		$ClientLabel.text = dia.none_at_door.pick_random()
		return

	if $DeliverySlot.item.state == "Wasted":
		$ClientLabel.text = dia.reject_potion.pick_random()
	else:
		if $DeliverySlot.item.name in curr_order:
			if $DeliverySlot.item.state == "Normal":
				$ClientLabel.text = dia.accept_potion.pick_random()
				pay.emit(6)
			else:
				$ClientLabel.text = dia.perfect_potion.pick_random()
				pay.emit(10)
				curr_order.erase($DeliverySlot.item.name)
			$DeliverySlot.empty()
		else:
			$ClientLabel.text = dia.reject_potion.pick_random()

	if curr_order.is_empty():
		client_at_door = false

	await get_tree().create_timer(3).timeout
	$ClientLabel.text = ""


#region Timers
func _on_new_client_timer_timeout() -> void:
	new_request()


func _on_patience_timer_timeout() -> void:
	client_at_door = false
	#client_gone.emit()
	$ClientLabel.text = ""
	$NewClientTimer.start(randf_range(40.0, 70.0))
#endregion


#region Buttons
func _on_check_door_pressed() -> void:
	$DoorWindow.show()
	$WindowOpen.play()
	$PatienceTimer.paused = true
	if curr_order != null:
		order.emit(curr_order)


func _on_open_store_pressed() -> void:
	$NewClientTimer.start()
	$OpenStore.hide()
	day_start.emit()


func _on_move_left_door_pressed() -> void:
	move_to_table.emit()
	$DoorWindow.hide()


func _on_move_right_door_pressed() -> void:
	move_to_stock.emit()
	$DoorWindow.hide()
#endregion


#region Helper
func show_help(which : String):
	helper.emit(which)


func hide_help():
	helper.emit("close")
#endregion
