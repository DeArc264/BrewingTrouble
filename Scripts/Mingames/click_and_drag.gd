extends Control
class_name ClickAndDrag

var clicked = false
var min_limit = Vector2.ZERO
var max_limit = Vector2.ZERO
var offset = Vector2.ZERO

func _ready() -> void:
	connect("gui_input", _on_gui_input)

func _process(_delta: float) -> void:
	if clicked and mouse_within_limit():
		global_position = get_global_mouse_position() - offset


func mouse_within_limit():
	var current_mouse_position = get_global_mouse_position()

	if current_mouse_position.x > min_limit.x and current_mouse_position.x < max_limit.x:
		if current_mouse_position.y > min_limit.y and current_mouse_position.y < max_limit.y:
			return true

	return false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		clicked = event.pressed
