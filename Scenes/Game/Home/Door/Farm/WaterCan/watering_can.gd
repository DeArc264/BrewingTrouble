extends TextureRect

var dragging = false
var watering = false
var filled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - Vector2(50, 50)
	else:
		pass


func watering_now():
	watering = !watering

	if watering:
		rotation = -45.0
	else:
		rotation = 0.0


func drag(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		dragging = event.pressed


func fill_can():
	if $Slot.item != null and $Slot.item.name == "Water":
		$Slot.empty()
		filled = true
		$Slot.hide()
		$WateringCan.monitorable = true


func empty_can():
	filled = false
	$Slot.show()
	$WateringCan.monitorable = false
