class_name InventorySlotGUI extends Button

@onready var bg : Sprite2D = $Background
@onready var center_container : CenterContainer = $CenterContainer
# set by inventory_gui
var inventory_res : Inventory
var item_in_slot : ItemStackGUI = null
var index : int

func insert_item(item_stack : ItemStackGUI):
	item_in_slot = item_stack
	bg.frame = 1
	center_container.add_child(item_in_slot)
	
	if item_in_slot.slot and inventory_res.slots[index] != item_in_slot.slot:
		inventory_res.insert_slot(index, item_in_slot.slot)

func take_item():
	var item = item_in_slot
	center_container.remove_child(item_in_slot)
	item_in_slot = null
	bg.frame = 0
	return item

func isEmpty() -> bool:
	return true if not item_in_slot else false
