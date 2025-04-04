extends Control

#region Variables and Signals
signal move_to_table
signal move_to_stock
signal day_start
signal pay (int)
signal order(String)

@export var possible_orders : Array[Item]
@onready var dia = load("res://Resources/Dialogue/NPCDialogues.tres")

var curr_order: Array[Item]
var delivery_box: Array[Item]
var slide = false
var client_at_door = false
#endregion

func _process(_delta: float) -> void:
	if not $DoorWindow.visible:
		$PatienceTimer.paused = false
		$ClientLabel.hide()
	else:
		$PatienceTimer.paused = true
		$ClientLabel.show()

	if slide:
		$Door_Window.position.x = clamp((get_global_mouse_position().x - 46), 15, 50)
	if $Door_Window.position.x == 15:
		check_door()
		$Door_Window.position.x = 50


func new_request():
	if client_at_door: return

	var temp_rand = randi_range(1,3)
	$FmodEventEmitter2D.play()
	client_at_door = true

	for i in range(temp_rand):
		curr_order.append(possible_orders.pick_random())

	$PatienceTimer.start(120 * temp_rand)
	$ClientLabel.text = dia.phrase_constructor(curr_order)


func deliver():
	if not client_at_door:
		$ClientLabel.text = dia.none_at_door.pick_random()
		await get_tree().create_timer(3).timeout
		$ClientLabel.text = ""
		return

	for slot in $DeliveryBox.get_children():
		if slot.item.state == "Wasted":
			$ClientLabel.text = dia.reject_potion.pick_random()
			await get_tree().create_timer(3).timeout
			$ClientLabel.text = ""
			return
		else:
			for item in curr_order:
				if item.id == slot.item.id:
					curr_order.erase(item)
					sell_potion(slot.item.state)
					break


func sell_potion(potion_state : String):
	if potion_state == "Normal":
		pay.emit(5)
	elif potion_state == "Perfect":
		pay.emit(5 * 1.25)


#region Timers
func _on_new_client_timer_timeout() -> void:
	new_request()


func _on_patience_timer_timeout() -> void:
	client_at_door = false
	#client_gone.emit()
	$ClientLabel.text = ""
	$NewClientTimer.start(randf_range(60.0, 90.0))
#endregion


#region Buttons
func check_door():
	$DoorWindow.show()
	#$WindowOpen.play()
	$PatienceTimer.paused = true

	if not curr_order.is_empty():
		var noted_order : Array[String]
		for item in curr_order:
			noted_order.append(item.name)
		order.emit(noted_order)


func _door_window_slide(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		slide = event.pressed


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


func _on_delivery_button_pressed() -> void:
	$DeliveryBox.visible = !$DeliveryBox.visible

	if $DeliveryBox.hidden:
		deliver()
#endregion
