extends Control

@onready var faces_m = load("res://Resources/Faces/male_faces.tres")

var slide = false

func _process(_delta: float) -> void:
	if slide:
		$Board.position.x = clamp((get_global_mouse_position().x - 300), -280, 0)
	
	if $Board.position.x == 0:
		hide()
		$Board.position.x = -280


func is_client_there():
	if $Shape.is_visible():
		client_gone()
	else:
		new_client()


func new_client():
	var randomizer = randi_range(0, 3)
	$Shape.play(str(randomizer))
	
	randomizer = randi_range(0, 3)
	$Shape/Nose.play(str(randomizer))
	
	randomizer = randi_range(0, 3)
	$Shape/Mouth.play(str(randomizer))
	
	randomizer = randi_range(0, 3)
	$Shape/Hair.play(str(randomizer))
	
	randomizer = randi_range(0, 3)
	$Shape/Eyes.play(str(randomizer))
	
	$Shape.show()


func client_gone() -> void:
	$Shape.hide()


func _drag_board(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		slide = event.pressed


func _on_door_day_start() -> void:
	$OutsideVideo.play()
