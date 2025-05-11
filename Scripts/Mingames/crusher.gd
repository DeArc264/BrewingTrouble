extends Minigame

@onready var label = $Label

func _on_bowl_crushing(area: Area2D) -> void:
	if area.name == "PebbleArea":
		increase_progress()

	if progress >= 1.0:
		current_ing.change_icon("crush")
		element.get_parent().texture = current_ing.icon
		level += 1
		progress = 0.0


func _on_button_pressed() -> void:
	if dirty:
		current_ing.conditions.append("useless")
		end_minigame()
		return

	else:
		match level:
			0:
				current_ing.conditions.append("uncrushed")
			1:
				current_ing.conditions.append("thick powder")
			2:
				current_ing.conditions.append("medium powder")
			3:
				current_ing.conditions.append("thin powder")
			_:
				current_ing.conditions.append("useless")

		reset()
		end_minigame()


func reset():
	$Pebble.position = Vector2(290, 10)
