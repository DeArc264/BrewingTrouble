extends Minigame

@onready var label = $Label

var img_dict = {
#Belladona
	"plant_0" : [
		load("res://Assets/Minigames/Mortar/Belladona/belladona_1.png"),
		load("res://Assets/Minigames/Mortar/Belladona/belladona_2.png"),
		load("res://Assets/Minigames/Mortar/Belladona/belladona_3.png")
	],
#Ginger
	"plant_1" : [
		load("res://Assets/Minigames/Mortar/Ginger/ginger_1.png"),
		load("res://Assets/Minigames/Mortar/Ginger/ginger_2.png"),
		load("res://Assets/Minigames/Mortar/Ginger/ginger_3.png")
	],
#Lavander
	"plant_2" : [
		load("res://Assets/Minigames/Mortar/Lavander/lavander_1.png"),
		load("res://Assets/Minigames/Mortar/Lavander/lavander_2.png"),
		load("res://Assets/Minigames/Mortar/Lavander/lavander_3.png")
	],
#Berries
	"plant_3" : [
		load("res://Assets/Minigames/Mortar/Berries/berries_1.png"),
		load("res://Assets/Minigames/Mortar/Berries/berries_2.png"),
		load("res://Assets/Minigames/Mortar/Berries/berries_3.png")
	]
}

func _on_bowl_crushing(area: Area2D) -> void:
	if area.name == "PebbleArea":
		$Crush.play()
		$Particles.play("default")
		increase_progress()

	if progress >= 1.0:
		change_icon(img_dict[current_ing.id])
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
		current_ing.icon = current_ing.crush_icon
		end_minigame()


func reset():
	$Pebble.position = Vector2(290, 10)
