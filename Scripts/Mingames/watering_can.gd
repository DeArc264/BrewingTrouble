extends TextureRect

var starting_pos
var dragging = false
var watering = false
var filled = 0.0


func _ready() -> void:
	starting_pos = global_position


func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - Vector2(50, 50)

	if watering:
		if filled != 0.0:
			filled -= 30 * delta

	clamp(filled, 0.0, 100.0)


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
		filled = 100.0
		$Slot.hide()
		$WateringCan.monitorable = true
