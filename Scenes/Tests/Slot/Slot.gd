extends PanelContainer
class_name Slot

signal dropped

@onready var texture_rect = $TextureRect


@export var item : Item = null:
	set(value):
		item = value
		if value != null:
			$TextureRect.texture = value.icon
		else:
			$TextureRect.texture = null


func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture
	preview_texture.position = -Vector2(50, 50)

	var preview = Control.new()
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.add_child(preview_texture)

	return preview

func _get_drag_data(_at_position):
	set_drag_preview(get_preview())
	return self

func _can_drop_data(_at_position, data):
	return data is Slot

func _drop_data(_at_position, data):
	var temp = item
	item = data.item
	data.item = temp
	dropped.emit()

func empty():
	item = null
