extends TextureRect

signal is_clean

@export var dirt_spots : PackedScene

var remaining = 3
var tool_textures = {
	"mortar" : "res://Assets/Icons/missing.png",
	"caldron" : "res://Assets/Icons/missing.png",
	"distill" : "res://Assets/Icons/missing.png"
}


func cahnge_texture(which : String):
	texture = tool_textures[which]
	show()


func start_cleaning():
	remaining = 3

	var new_dirt

	for i in range(remaining):
		new_dirt = dirt_spots.instantiate()
		new_dirt.new_dirty_spot()
		new_dirt.connect("cleaned", spot_cleaned)

		add_child(new_dirt)
		new_dirt.position = Vector2(randi_range(20, 300), randi_range(20, 160))


func spot_cleaned():
	remaining -= 1

	if remaining <= 0:
		is_clean.emit()
		await get_tree().create_timer(2).timeout
		hide()
