extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "Time remaining: " + str(int($Timer.time_left))


func _on_button_pressed() -> void:
	if $Timer.paused:
		$Timer.paused = false
	else:
		$Timer.paused = true
