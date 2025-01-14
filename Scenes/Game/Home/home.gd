extends Control


func _ready():
	$Events.show()
	$Door.hide()
	$Stock.hide()
	$Table.show()
	$HUD.show()


func to_table():
	$Door.hide()
	$Stock.hide()
	$Table.show()


func to_stock():
	$Door.hide()
	$Table.hide()
	$Stock.show()


func to_door():
	$Table.hide()
	$Stock.hide()
	$Door.show()


func change_room(room : String):
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished

	match room:
		"stock":
			to_stock()
		"table":
			to_table()
		"door":
			to_door()

	$AnimationPlayer.play("fade_out")


func _on_day_over() -> void:
	to_stock()
