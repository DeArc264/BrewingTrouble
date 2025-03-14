extends Control

@onready var faces_m = load("res://Resources/Faces/male_faces.tres")

var slide = false

func _process(_delta: float) -> void:
	if slide:
		$Board.position.x = clamp((get_global_mouse_position().x - 300), -280, 0)
	
	if $Board.position.x == 0:
		hide()
		$Board.position.x = -280

func new_client():
	$Shape.texture = faces_m.shape.pick_random()
	$Shape/Hair.texture = faces_m.hair.pick_random()
	$Shape/Ears.texture = faces_m.ears.pick_random()
	$Shape/Eyes.texture = faces_m.eyes.pick_random()
	$Shape/Eyebrows.texture = faces_m.eyebrows.pick_random()
	$Shape/Nose.texture = faces_m.nose.pick_random()
	$Shape/Mouth.texture = faces_m.mouth.pick_random()
	$Shape/Facial_Hair.texture = faces_m.facial_hair.pick_random()

	$Shape.show()


func client_gone() -> void:
	$Shape.hide()


func _drag_board(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		slide = event.pressed
