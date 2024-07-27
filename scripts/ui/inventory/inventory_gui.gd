class_name InventoryGUI extends Control

@onready var slot_gui_list : Array = $NinePatchRect/GridContainer.get_children()
@onready var item_stack_gui_scene = preload("res://scenes/ui/inventory/item_stack_gui.tscn")
var is_open = false
var inventory_res : Inventory

var item_in_hand : ItemStackGUI

func _ready():
	inventory_res = owner.inventory_res
	self.modulate.a = 0
	connect_slots()
	update_slots()

func connect_slots():
	for i in range(slot_gui_list.size()):
		var slot: InventorySlotGUI = slot_gui_list[i]
		slot.index = i
		slot.inventory_res = self.inventory_res
		
		var callable = Callable(_on_slot_clicked)
		callable = callable.bind(slot)
		slot.connect("pressed", callable)

func _on_slot_clicked(slot : InventorySlotGUI):
	if slot.isEmpty() and item_in_hand:
		insert_item_in_slot(slot)
	elif not item_in_hand:
		take_item_from_slot(slot)

func take_item_from_slot(slot : InventorySlotGUI):
	item_in_hand = slot.take_item()
	add_child(item_in_hand)
	update_item_in_hand()

func insert_item_in_slot(slot : InventorySlotGUI):
	var item : ItemStackGUI = item_in_hand
	remove_child(item_in_hand)
	item_in_hand = null
	slot.insert_item(item)

func update_item_in_hand():
	if not item_in_hand:
		return
	item_in_hand.global_position = get_global_mouse_position() - item_in_hand.size / 2

func _process(_delta):
	update_item_in_hand()

func update_slots():
	for i in range(min(inventory_res.slots.size(), slot_gui_list.size())):
		var inventory_slot : InventorySlot = inventory_res.slots[i]
		if not inventory_slot.item:
			return
		var item_stack : ItemStackGUI = slot_gui_list[i].item_in_slot
		if not item_stack:
			item_stack = item_stack_gui_scene.instantiate()
			slot_gui_list[i].insert_item(item_stack)
		item_stack.slot = inventory_slot
		item_stack.update_item()

func open_inventory():
	self.visible = true
	is_open = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5)
	SceneTransition.inventory_fade()

func close_inventory():
	is_open = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	SceneTransition.fade_to_normal_from_color(0.6)
