extends Control

signal day_over
signal new_day
signal buy_ingredient(String)

var coins = 10.0
var visible_notes = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$TimeLabel.hide()
	$Scroll/Hands.hide()
	$Coin/GoldLabel.text = str(coins)
	$Scroll.play("default")


func _get_item(item: Item) -> void:
	if $Scroll.frame == 0:
		$Scroll.play("open")
	$Scroll/Hands.add_item(item)

	await $Scroll.animation_finished
	$Scroll/Hands.show()


func _on_door_pay(ammount : int) -> void:
	$AnimationPlayer.play("coin")
	await $AnimationPlayer.animation_finished

	$CoinPaper/Coin.play("add")
	$CoinPaper/CoinLabel.text = "+ " + str(ammount)
	coins += ammount

	await $CoinPaper/Coin.animation_finished
	$AnimationPlayer.play_backwards("coin")


func buy_stuff(ing : String, price : float):
	if coins >= price:
		coins -= price
		$Coin/GoldLabel.text = str(coins)
		buy_ingredient.emit(ing)
	else:
		$PayLabel.show()
		await get_tree().create_timer(2).timeout
		$PayLabel.hide()

#region Day
func start_day():
	$DayTimer.start(600)
	$TimeLabel.show()
	new_day.emit()


func _on_day_timer_timeout() -> void:
	$DayTimer.stop()
	day_over.emit()
	$Store.show()
	$Coin.show()
#endregion


func show_hands():
	$HandButton.hide()

	if $Scroll.frame == 6:
		$Scroll.play_backwards("open")
		$Scroll/Hands.hide()
		await $Scroll.animation_finished
	elif $Scroll.frame == 0:
		$Scroll.play("open")
		await $Scroll.animation_finished
		$Scroll/Hands.show()

	$HandButton.show()

#region Note Tab
func show_notes():
	if visible_notes:
		$AnimationPlayer.play_backwards("note")
	else:
		$AnimationPlayer.play("note")

	visible_notes = !visible_notes


func update_note(note : Array[Item]):
	var icons := {
		"potion_1": "res://Assets/Icons/Potions/Flask_A/flask_a_heal.png",
		"potion_2": "res://Assets/Icons/Potions/Flask_A/flask_a_stamina.png",
		"potion_3": "res://Assets/Icons/Potions/Flask_A/flask_a_strenght.png"
	}

	var children = $OrdersNote/VBoxContainer.get_children()

	for i in range(children.size()):
		var texture_rect = children[i]
		if i < note.size():
			var order = note[i]
			var icon_path = icons.get(order.id, "res://Assets/Icons/missing.png")
			texture_rect.texture = load(icon_path)
		else:
			texture_rect.texture = null

	$AnimationPlayer.play("note")
	get_tree().create_timer(2).timeout
	$AnimationPlayer.play_backwards("note")
#endregion


#region Helper
func helper_control(which : String):
	var new_text = " "

	$Helper.show()

	match which:
		"distill":
			new_text = "Still"
		"hour":
			new_text = "Timer"
		"bellow":
			new_text = "Bellow"
		"caldron":
			new_text = "Caldron"
		"dry":
			new_text = "Dryer"
		"book":
			new_text = "Book"
		"crush":
			new_text = "Mortar"
		"pots":
			new_text = "Pots"
		"trash":
			new_text = "Trash"
		"door":
			new_text = "Deliver"
		"close":
			$Helper.hide()

	if which == "trash":
		$Helper.offset.x = -610
		$Helper/HelperLabel.position.x = -545
	else:
		$Helper.offset = Vector2.ZERO
		$Helper/HelperLabel.position.x = 65

	$Helper/HelperLabel.text = new_text
#endregion
