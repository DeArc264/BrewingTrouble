extends GridContainer

signal hands_full(item : String)

func add_item(item):
	for i in get_children():
		if i.item == null:
			i.item = item
			return
		else:
			hands_full.emit(item.name)

func remove_item(item):
	for i in get_children():
		if i.item == item:
			i.item = null
			return

func is_avaliable(item):
	for i in get_children():
		if i.item == item:
			return true
	return false
