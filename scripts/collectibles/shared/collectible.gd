class_name Collectible extends Node2D
@export var collectible_res : InventoryItem
@onready var area = $Area2D
var inventory_gui : InventoryGUI

func _ready():
	area.body_entered.connect(collect)

func collect(body):
	if body is Player:
		inventory_gui = body.inventory_gui
		self.insert_into_inventory()
		inventory_gui.update_slots()
		self.queue_free()

func insert_into_inventory():
	var slot_list : Array[InventorySlot] = inventory_gui.inventory_res.slots
	for slot : InventorySlot in slot_list:
		if slot.item == collectible_res and slot.amount < collectible_res.max_amount:
			slot.amount += 1
			return
	for i in range(slot_list.size()):
		if not slot_list[i].item:
			slot_list[i].item = collectible_res
			slot_list[i].amount = 1
			return
