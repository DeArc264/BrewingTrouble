extends Control

@onready var faces_m = load("res://Resources/Faces/male_faces.tres")

func new_client():
	$Shape.texture = load(faces_m.shape.pick_random())
	$Shape/Ears.texture = load(faces_m.ears.pick_random())
	$Shape/Eyes.texture = load(faces_m.eyes.pick_random())
	$Shape/Nose.texture = load(faces_m.nose.pick_random())
	$Shape/Mouth.texture = load(faces_m.mouth.pick_random())

	$Shape.show()


func _on_door_client_gone() -> void:
	$Shape.hide()


func _on_back_pressed() -> void:
	hide()
