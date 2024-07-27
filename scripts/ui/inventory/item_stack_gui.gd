class_name ItemStackGUI extends Panel

@onready var item_sprite : Sprite2D = $Item
@onready var item_count : Label = $Label
var slot : InventorySlot

func update_item():
	if not (slot or slot.item):
		return
	item_sprite.texture = slot.item.texture
	item_sprite.scale = Vector2(7.5, 7.5)
	item_count.text = str(slot.amount)
	item_sprite.visible = true
	item_count.visible = slot.amount > 1
