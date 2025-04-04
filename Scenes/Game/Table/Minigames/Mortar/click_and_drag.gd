extends TextureRect

var dragging = false
var mouse_pos
var of = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging:
		mouse_pos = get_global_mouse_position()
		if mouse_pos.y <= 373:
			position.y = get_global_mouse_position().y


func start_dragging(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		dragging = event.pressed

	if name == "Pebble":
		of = Vector2(40, 10)
	elif name == "Spoon":
		of = Vector2(20, 20)
	elif name == "Knife":
		of = Vector2(15, 300)
