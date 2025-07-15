extends Control

var page_index = 0

func _ready() -> void:
	change_page(page_index)


func _on_return_button_pressed() -> void:
	hide()


func _on_next_button_pressed() -> void:
	page_index += 1
	$Tools.hide()
	$Healing.hide()
	$Stamina.hide()
	$Strenght.hide()
	$Soon.hide()

	$TurnPages.play("turn")
	await $TurnPages.animation_finished

	update_buttons()
	change_page(page_index)


func _on_previous_button_pressed() -> void:
	page_index -= 1

	$Tools.hide()
	$Healing.hide()
	$Stamina.hide()
	$Strenght.hide()
	$Soon.hide()

	$TurnPages.play_backwards("turn")
	await $TurnPages.animation_finished

	update_buttons()
	change_page(page_index)


func change_page(ind : int):
	match ind:
		0:
			$Tools.show()
			$Healing.hide()
			$Stamina.hide()
			$Strenght.hide()
			$Soon.hide()
		1:
			$Tools.hide()
			$Healing.show()
			$Stamina.show()
			$Strenght.hide()
			$Soon.hide()
		2:
			$Tools.hide()
			$Healing.hide()
			$Stamina.hide()
			$Strenght.show()
			$Soon.show()


func update_buttons():
	$NextButton.hide()
	$PreviousButton.hide()

	if page_index == 1:
		$NextButton.show()
		$PreviousButton.show()
	elif page_index == 0:
		$NextButton.show()
	elif page_index == 2:
		$PreviousButton.show()
