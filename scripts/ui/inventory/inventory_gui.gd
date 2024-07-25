class_name Inventory extends Control

var is_open = false

func _ready():
	self.modulate.a = 0

func open_inventory():
	self.visible = true
	is_open = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5).from(0)

func close_inventory():
	is_open = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
