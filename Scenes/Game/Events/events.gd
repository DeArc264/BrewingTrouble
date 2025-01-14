extends Control

@onready var cutscene = load("res://Resources/cutscenes.gd").new()
@onready var dialogue = $Dia_Box/Label

var tween
var step = 0
var sub_step = 0
var curr_tut

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_tut_dia()


func current_tut_dia():
	match step:
		0:
			curr_tut = cutscene.start_speech
		1:
			curr_tut = cutscene.stock_tutorial
		2:
			curr_tut = cutscene.door_tutorial
		3:
			curr_tut = cutscene.table_tutorial

	dialogue.text = curr_tut[0]
	update_text()


func update_text():
	dialogue.visible_ratio = 0
	if tween and is_instance_valid(tween):
		tween.stop()

	tween = get_tree().create_tween()
	tween.tween_property(dialogue, "visible_ratio", 1, 3)


func _on_button_pressed() -> void:
	show()
	var next_text = cutscene.next_index(dialogue.text)

	match step:
		0:
			if next_text < curr_tut.size():
				dialogue.text = curr_tut[next_text]
				update_text()
			else:
				step += 1
				change_room("stock")
		1:
			if next_text == 1:
				$Dia_Box.hide()
			elif next_text < curr_tut.size():
				dialogue.text = curr_tut[next_text]
				update_text()
			else:
				step += 1
				change_room("door")
				
		2:
			if next_text == 4:
				$Dia_Box.hide()
			elif next_text < curr_tut.size():
				dialogue.text = curr_tut[next_text]
				update_text()
			else:
				step += 1
				change_room("table")
		3:
			if next_text == 1:
				$Dia_Box.hide()
			elif next_text < curr_tut.size():
				dialogue.text = curr_tut[next_text]
				update_text()
			else:
				queue_free()


func continue_tutorial():
	$Dia_Box.show()
	dialogue.text = curr_tut[cutscene.next_index(dialogue.text)]


func _on_stock_button_pressed() -> void:
	$Stock_BG/Stock.show()
	continue_tutorial()


func _on_door_button_pressed() -> void:
	$Door/DoorWindow.show()
	continue_tutorial()


func _on_book_button_pressed() -> void:
	$Table/Book.show()
	continue_tutorial()


func change_room(room : String):
	$Dia_Box.hide()
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished

	match room:
		"stock":
			$Table.hide()
			$Door.hide()
			$Stock_BG.show()
		"table":
			$Table.show()
			$Door.hide()
			$Stock_BG.hide()
		"door":
			$Table.hide()
			$Door.show()
			$Stock_BG.hide()

	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished

	$Dia_Box.show()
	current_tut_dia()
