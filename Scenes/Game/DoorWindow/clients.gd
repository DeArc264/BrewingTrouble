extends Control

@onready var faces_m = load("res://Resources/Faces/male_faces.tres")

func new_client():
	$Shape.texture = faces_m.shape.pick_random()
	$Shape/Ears.texture = faces_m.ears.pick_random()
	$Shape/Eyes.texture = faces_m.eyes.pick_random()
	$Shape/Eyebrows.texture = faces_m.eyebrows.pick_random()
	$Shape/Nose.texture = faces_m.nose.pick_random()
	$Shape/Mouth.texture = faces_m.mouth.pick_random()
	$Shape/Facial_Hair.texture = faces_m.facial_hair.pick_random()
	$Shape/Hair.texture = faces_m.hair.pick_random()

	$Shape.show()


func _on_door_client_gone() -> void:
	$Shape.hide()


func _on_back_pressed() -> void:
	hide()
	$WindowClose.play()
