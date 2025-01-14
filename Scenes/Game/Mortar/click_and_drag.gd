extends TextureRect

var dragging = false
var of = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - of


func _on_button_button_down() -> void:
	if name == "Mortar":
		of = Vector2(40, 10)
	elif name == "Spoon":
		of = Vector2(20, 20)
	elif name == "Knife":
		of = Vector2(15, 300)
	dragging = true


func _on_button_button_up() -> void:
	dragging = false
