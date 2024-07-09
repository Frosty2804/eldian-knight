class_name TimersComponent extends Node

var parent : Node

func _ready():
	var parent_node = get_parent()
	if not parent_node.has_node("Timers"):
		var timers_node = Node.new()
		timers_node.name = "Timers"
		parent_node.add_child.call_deferred(timers_node)
		parent = timers_node

func create_timer(is_one_shot,connect_func = null) -> Timer:
	#var parent = get_node("Timers")
	var timer = Timer.new()
	timer.one_shot = is_one_shot
	parent.add_child(timer)
	if connect_func:
		timer.connect("timeout", connect_func)
	return timer
