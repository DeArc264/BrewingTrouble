extends Resource
class_name Dialogue

#region Recieve Potions
var accept_potion = [
	"Thank you. Here is the gold.",
	"I hope this works...",
	"Thanks!",
	"What took you so long?"
]

var perfect_potion = [
	"Oh! That looks really well made!",
	"Wow!",
	"Impressive work! Keep the change.",
	"I have to come back again!"
]

var reject_potion = [
	"That's... Not what I ordered.",
	"What is this? I'm not paying for that!",
	"Ugh... I should have looked for a better store...",
	"Huh? That's not what I wanted!"
]
#endregion

var order_potion = [
	"Quick! I need ",
	"Hello. I would like to order ",
	"Hey, I need you to make ",
	"Please, brew me "
		]

var none_at_door = [
	"Huh? Is he already gone?",
	"Ugh... Guess I took too long...",
	"Oh... He's gone already.."
]


func phrase_constructor(order : Array):
	var count_dict = {}

	for i in order:
		if i in count_dict:
			count_dict[i] += 1
		else:
			count_dict[i] = 1

	var order_parts = []
	for potion in count_dict:
		var count = count_dict[potion]
		if count > 1:
			order_parts.append(str(count) + " " + potion + "s")
		else:
			order_parts.append("a " + potion)
	
	if len(order_parts) == 1:
		return order_potion.pick_random() + order_parts[0] + "."
	if len(order_parts) == 2:
		return order_potion.pick_random() + order_parts[0] + " and " + order_parts[1] + "."
	else:
		return order_potion.pick_random() + ", ".join(order_parts.slice(0, -1)) + ", and " + order_parts[-1] + "."
