extends Node

var start_speech = [
	"It's already been... How long again? I can't remember...",
	"Still, I'm running out of food... I need to buy more. Where's my pouch?",
	"Oh... It's almost empty... At this rate, I'll end up begging or starving.",
	"Ugh... I have to move... I have to work... Let's see..."
]

var stock_tutorial = [
	"Hmmm... What do I have in stock right now? I hope it didn't spoil.",
	"..........",
	"Phew... Perhaps it wasn't that long after all. But I only have a few...",
	"The air is so stiff... I need a bit of fresh air."
]

var door_tutorial = [
	"*cough* *cough* Ugh...",
	".........",
	"I don't want to open the door...",
	"Just the window will do...",
	"Aaah... The world outside is just like I remember it...",
	"But I still don't want to leave...",
	"Hmm... Either way, I have to make coin.",
	"I still have enough ingredients. How's the table?"
]

var table_tutorial = [
	"Dusty... But at least nothing is broken. And my book...",
	"I could swear I had more recipes noted... I'll have to mix new things later.",
	"I should try to brew something... A simple Healing Potion, maybe?",
	"First, grab the ingredients...",
	"A liquid base and two ingredients..."
]


func next_index(dia : String):
	var curr_dialogue = indentify_dialogue(dia)
	var curr_index = curr_dialogue.find(dia, 0)

	if curr_index > curr_dialogue.size() - 1:
		curr_index = 0
	else:
		curr_index += 1

	return curr_index


func indentify_dialogue(dia : String):
	if start_speech.has(dia):
		return start_speech
	elif stock_tutorial.has(dia):
		return stock_tutorial
	elif table_tutorial.has(dia):
		return table_tutorial
	elif door_tutorial.has(dia):
		return door_tutorial
