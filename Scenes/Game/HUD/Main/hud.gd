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

	$Helper.position = get_global_mouse_position()


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


#region Helper
func helper_control(which : String):
	var new_text = " "

	$Helper.show()

	match which:
		"distill":
			new_text = "Drop an ingredient to distill\n\nNOTE: Ores can't be distilled"
		"hour":
			new_text = "Click to turn\n\nEach turn counts 10 seconds"
		"bellow":
			new_text = "Click to raise fire and boil liquid\n\nNOTE: The fire goes out with time"
		"caldron":
			new_text = "Drop ingredients here to make your potion"
		"dry":
			new_text = "Drop a Plant to dry it\n\nNOTE: Pay attentention to how it looks"
		"book":
			new_text = "All your recipes are here"
		"crush":
			new_text = "Drop an ingredient to start crushing"
		"pots":
			new_text = "Keep items for later"
		"trash":
			new_text = "Discart items you don't need"
		"door":
			new_text = "Drop a potion to deliver it"
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
