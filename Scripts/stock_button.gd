extends TextureButton

@export var normal_icon : Texture2D
@export var half_icon : Texture2D
@export var empty_icon : Texture2D
@export var pick_up_icon : TextureRect

var quantity


func _ready() -> void:
	self.connect("pressed", change_texture)
	change_texture()


func change_texture():
	quantity = get_parent().ing_dict[name]
	if quantity >= 3:
		texture_normal = normal_icon
	elif quantity < 3 and quantity > 0:
		texture_normal = half_icon
	else:
		if empty_icon:
			texture_normal = empty_icon
		else:
			hide()

	if quantity <= 0:
		mouse_default_cursor_shape = CURSOR_FORBIDDEN
	else:
		mouse_default_cursor_shape = CURSOR_POINTING_HAND


func _on_mouse_entered() -> void:
	pick_up_icon.show()


func _on_mouse_exited() -> void:
		pick_up_icon.hide()
