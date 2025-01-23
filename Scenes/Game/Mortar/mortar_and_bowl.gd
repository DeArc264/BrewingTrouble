extends Control

signal crushed(Item)

@onready var progress = $Background/ProgressBar
@onready var label = $Background/Label

@export var crush_sounds : Array[AudioStreamWAV]

var ing : Item
var dirty = false


func _on_bowl_crushing(area: Area2D) -> void:
	if area.name == "PebbleArea":
		progress.value += 1


func _on_button_pressed() -> void:
	if dirty:
		ing.useless = true
	else:
		if progress.value < 10:
			if progress.value > 4 and progress.value < 7:
				label.text = "Perfect!"
				ing.conditions.append("crushed")
				ing.rank += 1
			else:
				label.text = "Crushed!"
				ing.conditions.append("crushed")
			label.show()
		else:
			ing.conditions.append("useless")

	ing.change_icon("crushed")
	progress.value = 0
	crushed.emit(ing)

	await get_tree().create_timer(1.5).timeout
	label.text = ""
	hide()


func _on_table_crush(item: Item) -> void:
	if item.type == "Plant":
		ing = item
		show()
	#elif item.type == "Ore" or item.type == "Base" or item.conditions.has("useless"):
		#dirty = true
	#else:
		#dirty = false


func play_audio():
	if $Sounds.playing:
		$Sounds.stop()

	$Sounds.stream = crush_sounds.pick_random()
	$Sounds.play()
