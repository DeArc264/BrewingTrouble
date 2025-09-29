extends Control

var dialogues = [
	"I wonder when the professor will return...",
	"Not long, if I'm lucky...",
	"Anyway, I should rest."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play("speech")
	await $AnimationPlayer.animation_finished

	play_speech()


func play_speech():
	$Speech/SpeechLabel.text = "What a day..."
	$AnimationPlayer.play("text")
	await get_tree().create_timer(3).timeout

	for text in dialogues:
		$Speech/SpeechLabel.text = text
		$AnimationPlayer.play("text")
		await get_tree().create_timer(3).timeout

	$AnimationPlayer.play_backwards("speech")
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play_backwards("fade")
	await get_tree().create_timer(3).timeout

	$AnimationPlayer.play("extra_label")
	await $AnimationPlayer.animation_finished
	ending()


func ending():
	$Speech/SpeechLabel.visible_ratio = 0
	if Itens.requests_fulfilled >= 5:
		$EndingScreen.texture = load("res://Assets/HUD/EndScreen/bad_ending.png")
		$Speech/SpeechLabel.text = "Oh... Oh no... Is that... One of my flasks?"
	else:
		$EndingScreen.texture = load("res://Assets/HUD/EndScreen/good_ending.png")
		$Speech/SpeechLabel.text = "Hmmm... Goat cheese..."

	$EndingScreen.show()

	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play("speech")
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play("text")
	await get_tree().create_timer(3).timeout

	$AnimationPlayer.play_backwards("speech")
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play_backwards("fade")
	$ExtraLabel.text = "End of Demo\nThanks for playing!"
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play("extra_label")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Game/menu.tscn")
