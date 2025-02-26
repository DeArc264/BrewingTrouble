extends CharacterBody2D

var clicked = false
var target_pos
var move_vec

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if clicked:
		target_pos = get_global_mouse_position()
		move_vec = (target_pos - global_position).normalized() * 300 * delta

	move_and_slide()


func _on_button_button_down() -> void:
	clicked = true


func _on_button_button_up() -> void:
	clicked = false
