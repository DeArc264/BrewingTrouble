extends Control

signal new_ing(Item)

var img_empty = "res://Assets/Table/drying_net_empty.png"
var img_full = "res://Assets/Table/drying_net.png"
var level = 0
var can_dry = false

func _process(delta: float) -> void:
	if can_dry:
		$Timer.paused = false
	else:
		$Timer.paused = true


func _on_slot_dropped() -> void:
	if $Slot.item.type == "Plant":
		self.texture = img_full
		$Timer.start(10)
		$EndButton.show()


func _on_timer_timeout() -> void:
	level += 1
	$Slot.item.change_icon("dry")


func _on_end_button_pressed() -> void:
	$Timer.stop()

	match level:
		0:
			$Slot.item.conditions.append("normal")
		1:
			$Slot.item.conditions.append("slightly dry")
		2:
			$Slot.item.conditions.append("dry")
		3:
			$Slot.item.conditions.append("dehydrated")
		_:
			$Slot.item.conditions.append("useless")

	new_ing.emit($Slot.item)
	$Slot.empty()
	self.texture = img_empty
	$EndButton.hide()
