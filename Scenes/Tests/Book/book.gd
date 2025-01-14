extends Control

func _on_return_button_pressed() -> void:
	hide()


func _on_next_button_pressed() -> void:
	$Page1.hide()
	$Page2.show()

	$NextButton.hide()
	$PreviousButton.show()


func _on_previous_button_pressed() -> void:
	$Page1.show()
	$Page2.hide()

	$NextButton.show()
	$PreviousButton.hide()
