extends Control

signal mixed(potion_id : String)

var texture_out = "res://Assets/Minigames/Caldron/spoon.png"
var texture_in = "res://Assets/Minigames/Caldron/spoon_in.png"

var mixing = false
var progress = 0.0
var liquid_base
var potion_color
var to_send
var tween

#func _ready() -> void:
	#start_minigame("base_1", "potion_1")

func start_minigame(base : String, brewed : String):
	match base:
		"base_0":
			liquid_base = "milk_"
		"base_1":
			liquid_base = "water_"
		"base_2":
			liquid_base = "wine_"

	match brewed:
		"potion_0":
			potion_color = Color.BLACK
		"potion_1":
			potion_color = Color.GREEN
		"potion_2":
			potion_color = Color.YELLOW
		"potion_3":
			potion_color = Color.RED
		_:
			potion_color = Color.BLACK
	to_send = brewed

	$Liquid.play(liquid_base + "bubble")
	$EndButton.hide()
	show()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "SpoonArea":
		progress += 0.05
		mixing = true
		$MixTimer.start(3)


func _on_mix_timer_timeout() -> void:
	mixing = false


func _on_liquid_animation_looped() -> void:
	if mixing:
		if $Liquid.animation == liquid_base + "bubble" or $Liquid.animation == liquid_base + "still":
			$Liquid.play(liquid_base + "mix")
			change_color()
	else:
		if $Liquid.animation == liquid_base + "mix":
			$Liquid.play(liquid_base + "still")
			tween.stop()


func change_color():
	tween = get_tree().create_tween()

	tween.tween_property($Liquid, "modulate", potion_color, 5)
	if tween.finished:
		$EndButton.show()


func _on_end_button_pressed() -> void:
	mixed.emit(to_send)
	hide()
