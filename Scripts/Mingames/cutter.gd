extends Minigame

func _cut(area: Area2D) -> void:
	if area.name == "KnifeArea":
		$Cut.play()
		progress += 0.1
		if progress >= 1.0:
			current_ing.change_icon("cut")
			element.get_parent().texture = current_ing.icon
			level += 1
			progress = 0

#["uncut", "thick slice", "medium slice", "thin slice"]
func _on_end_button_pressed() -> void:
	if dirty:
		current_ing.conditions.append("useless")
		end_minigame()
		return

	else:
		match level:
			0:
				current_ing.conditions.append("uncut")
			1:
				current_ing.conditions.append("thick slice")
			2:
				current_ing.conditions.append("medium slice")
			3:
				current_ing.conditions.append("thin slice")
			_:
				current_ing.conditions.append("useless")

		reset()
		end_minigame()


func reset():
	$Knife.position = Vector2(130, 10)
