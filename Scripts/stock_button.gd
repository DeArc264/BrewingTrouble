extends TextureButton

@export var normal_icon : Texture2D
@export var half_icon : Texture2D
@export var empty_icon : Texture2D

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
