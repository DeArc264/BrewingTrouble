extends TextureRect

signal cleaned

var cleaning_speed = 0.3
var spot_textures = ["res://Assets/Clean/spot_small.png", "res://Assets/Clean/spot_medium.png", "res://Assets/Clean/spot_big.png"]

func new_dirty_spot():
	modulate.a = 225
	
	var spot_size = randi_range(0, 2)
	texture = load(spot_textures[spot_size])

	match spot_size:
		0:
			cleaning_speed = 25
		1:
			cleaning_speed = 23
		2:
			cleaning_speed = 20


func _on_mouse_entered() -> void:
	modulate.a -= cleaning_speed

	if modulate.a <= 0.0:
		cleaned.emit()
