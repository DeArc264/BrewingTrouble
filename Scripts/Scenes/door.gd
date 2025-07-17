extends Control

#region Variables and Signals
signal move_to_table
signal move_to_stock
signal day_start
signal pay (int)
signal order(Array)
signal client_signal

@export var possible_orders : Array[Item]
@onready var dia = load("res://Resources/Dialogue/NPCDialogues.tres")
@onready var delivery_node = $DeliveryBoxBG/DeliveryBox

var curr_order: Array[Item]
var delivery_box: Array[Item]
var slide = false
var client_at_door = false
var price
#endregion

func _ready() -> void:
	$OutsideVideo.paused = true

func _process(_delta: float) -> void:
	if not $DoorWindow.visible:
		$PatienceTimer.paused = false
		$SpeachTexture.hide()
	else:
		$PatienceTimer.paused = true
		$SpeachTexture.show()

	if slide:
		$Door_Window.position.x = clamp((get_global_mouse_position().x - 46), 15, 50)
	if $Door_Window.position.x == 15:
		check_door()
		$Door_Window.position.x = 50


func new_request():
	if client_at_door: return

	var temp_rand = randi_range(1,3)
	$Knocking.play()
	client_at_door = true
	client_signal.emit()
	$DeliveryTexture.show()
	$DeliveryBoxBG.show()

	for i in range(temp_rand):
		curr_order.append(possible_orders.pick_random())

	$PatienceTimer.start(120 * temp_rand)
	$SpeachTexture/ClientLabel.text = dia.phrase_constructor(curr_order)


func sell_potion(potion_state : String):
	if potion_state == "Normal":
		price += 5
	elif potion_state == "Perfect":
		price += 5 * 1.25

	pay.emit(price)
	price = 0

	client_at_door = false
	$MaleAccept.play()
	$DeliveryTexture.hide()


#region Timers
func _on_new_client_timer_timeout() -> void:
	new_request()


func _on_patience_timer_timeout() -> void:
	client_at_door = false
	client_signal.emit()
	$SpeachTexture/ClientLabel.text = ""
	$NewClientTimer.start(randf_range(60.0, 90.0))
#endregion


#region Buttons
func check_door():
	$DoorWindow.show()
	#$WindowOpen.play()
	if client_at_door: 
		$MaleAccept.play()
		$PatienceTimer.paused = true

	if not curr_order.is_empty():
		order.emit(curr_order)


func _door_window_slide(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		slide = event.pressed


func _on_open_store_pressed() -> void:
	$NewClientTimer.start()
	$OpenTexture.hide()
	$OutsideVideo.paused = false
	day_start.emit()


func _on_move_left_door_pressed() -> void:
	move_to_table.emit()
	$DoorWindow.hide()


func _on_move_right_door_pressed() -> void:
	move_to_stock.emit()
	$DoorWindow.hide()


func _on_delivery_button_pressed() -> void:
	$DeliveryTexture.hide()

	if not client_at_door:
		$SpeachTexture.show()
		$SpeachTexture/ClientLabel.text = dia.none_at_door.pick_random()
		await get_tree().create_timer(3).timeout
		$SpeachTexture.hide()
		$SpeachTexture/ClientLabel.text = ""
		return

	var delivered_ids := []

	# Coleta os IDs dos itens entregues, e verifica se algum está "Wasted"
	for slot in delivery_node.get_children():
		if slot.item == null:
			continue

		if slot.item.state == "Wasted":
			var stored_order = $SpeachTexture/ClientLabel.text
			$SpeachTexture/ClientLabel.text = dia.reject_potion.pick_random()
			$MaleReject.play()
			$DeliveryTexture.show()
			await get_tree().create_timer(3).timeout
			$SpeachTexture/ClientLabel.text = stored_order
			return

		delivered_ids.append(slot.item.id)

	# Verifica se todos os itens da ordem estão entre os entregues
	var order_ids := curr_order.map(func(i): return i.id)

	var all_found := true
	for id in order_ids:
		if not delivered_ids.has(id):
			all_found = false
			break

	if not all_found:
		$MySpeechTexture.show()
		$MySpeechTexture/MySpeechLabel.text = "I still don't have all the itens!"
		await get_tree().create_timer(2).timeout
		$MySpeechTexture.hide()
		$DeliveryTexture.show()
		return

	for slot in delivery_node.get_children():
		Itens.requests_fulfilled += 1
		if slot.item != null:
			sell_potion(slot.item.state)
			slot.empty()

	$SpeachTexture/ClientLabel.text = ""

	curr_order.clear()
#endregion


func _on_discard_slot_dropped() -> void:
	$DiscardSlot.empty()
