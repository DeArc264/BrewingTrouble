extends Minigame

var img_dict = {
#Belladona
	"plant_0" : [
		load("res://Assets/Minigames/Cut/Belladona/belladona_1.png"),
		load("res://Assets/Minigames/Cut/Belladona/belladona_2.png"),
		load("res://Assets/Minigames/Cut/Belladona/belladona_3.png")
	],
#Ginger
	"plant_1" : [
		load("res://Assets/Minigames/Cut/Ginger/ginger_1.png"),
		load("res://Assets/Minigames/Cut/Ginger/ginger_2.png"),
		load("res://Assets/Minigames/Cut/Ginger/ginger_3.png")
	],
#Lavander
	"plant_2" : [
		load("res://Assets/Minigames/Cut/Lavander/lavander_1.png"),
		load("res://Assets/Minigames/Cut/Lavander/lavander_2.png"),
		load("res://Assets/Minigames/Cut/Lavander/lavander_3.png")
	],
#Berries
	"plant_3" : [
		load("res://Assets/Minigames/Cut/Berries/berries_1.png"),
		load("res://Assets/Minigames/Cut/Berries/berries_2.png"),
		load("res://Assets/Minigames/Cut/Berries/berries_3.png")
	]
}

func _cut(area: Area2D) -> void:
	if area.name == "KnifeArea":
		$Cut.play()
		$Particles.play("default")
		increase_progress()

		if progress >= 1.0:
			change_icon(img_dict[current_ing.id])
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
				current_ing.conditions.append("cut")
			2:
				current_ing.conditions.append("cut")
			3:
				current_ing.conditions.append("cut")
			_:
				current_ing.conditions.append("useless")

		reset()
		current_ing.icon = current_ing.cut_icon
		end_minigame()


func reset():
	$Slot.empty()
	$Knife.position = Vector2(130, 10)
