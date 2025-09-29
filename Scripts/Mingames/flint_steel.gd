extends Control

var counter = 0


func _ready() -> void:
	$SparkAnimations.play("default")


func hit(area: Area2D) -> void:
	if area.name == $Steel/SteelArea2D.name:
		counter += 1

		if counter >= 3:
			$SparkAnimations.play("success")
			counter = 0
		else:
			$SparkAnimations.play("common")
