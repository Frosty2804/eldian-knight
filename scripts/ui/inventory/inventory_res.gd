class_name Inventory extends Resource

@export var slots : Array[InventorySlot]

func remove_item_at_index(index : int):
	slots[index] = InventorySlot.new()

func insert_slot(index : int, inventory_slot : InventorySlot):
	var old_index : int = slots.find(inventory_slot)
	remove_item_at_index(old_index)
	slots[index] = inventory_slot
