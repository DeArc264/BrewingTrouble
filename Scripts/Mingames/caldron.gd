extends Control

signal mixed

@onready var c_progress = $Background/ProgressBar
@onready var spoon = $Background/Spoon/SpoonArea

var mix : int
var dirty = false


func _mixer(area: Area2D) -> void:
	if area.name == "SpoonArea":
		if mix < 9:
			mix += 1
			c_progress.value = mix
			
		else:
			spoon.set_deferred("monitorable",false)
			mix = 0
			c_progress.value = mix
			$Background/MixedLabel.show()
			mixed.emit()
			c_progress.value = 0
			await get_tree().create_timer(1.5).timeout
			spoon.set_deferred("monitorable",true)
			hide()
