extends TextureRect

signal cleaned

var cleaning_speed = 0.3
var spot_textures = ["res://Assets/Icons/missing.png", "res://Assets/Icons/missing.png", "res://Assets/Icons/missing.png"]

func new_dirty_spot():
	modulate.a = 1
	
	var spot_size = randi_range(0, 2)
	texture = load(spot_textures[spot_size])

	match spot_size:
		0:
			cleaning_speed = 0.5
		1:
			cleaning_speed = 0.3
		2:
			cleaning_speed = 0.2


func _on_mouse_entered() -> void:
	modulate.a -= cleaning_speed

	if modulate.a <= 0.0:
		cleaned.emit()
