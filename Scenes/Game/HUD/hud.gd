extends Control

signal day_over
signal new_day
signal buy_ingredient(String)

var coins = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$TimeLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CoinLabel.text = "Coins: " + str(coins)
	$TimeLabel.text = "Time: " + str(int($DayTimer.time_left))


func _get_item(item: Item) -> void:
	$Hands.add_item(item)


func _on_door_pay(ammount : int) -> void:
	coins += ammount


func buy_stuff(ing : String, price : float):
	if coins >= price:
		coins -= price
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
#endregion


#region Note Tab
func _show_note() -> void:
	$AnimationPlayer.play("go_up")


func _hide_note() -> void:
	$AnimationPlayer.play("go_down")


func update_note(note : String):
	$OrderNote/OrderLabel.text = note
#endregion
