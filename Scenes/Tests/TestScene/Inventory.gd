extends HBoxContainer

signal hands_full(item : String)

func add_item(item):
	if any_slot_avaliable():
		for i in get_children():
			if i.item == null:
				i.item = item
				return
	else:
		hands_full.emit(item.name)

func remove_item(item):
	for i in get_children():
		if i.item.id == item.id:
			i.item = null
			return

func any_slot_avaliable():
	for i in get_children():
		if i.item == null:
			return true
	return false
