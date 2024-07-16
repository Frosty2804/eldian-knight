class_name NPCInteractionComponent extends Area2D

signal change_state(next_state)

var entity : Entity = null
var idle_state : EntityIdleState

func _ready():
	Dialogic.signal_event.connect(_on_dialog_manager_signal_recieved)
	body_entered.connect(_in_interaction_range)
	body_exited.connect(_exit_interaction_range)
	idle_state = owner.idle_state

func _in_interaction_range(body):
	if body is Player:
		body.in_convo_range = true
		entity = body
		entity.connect("init_convo", _on_init_convo)

func _exit_interaction_range(_body):
	if not entity == null:
		entity.in_convo_range = false
		entity.disconnect("init_convo", _on_init_convo)
		entity = null

func _on_init_convo():
	change_state.emit(idle_state)
	Dialogic.start("reaper_intro")
	entity.in_convo = true

func _on_dialog_manager_signal_recieved(signal_name : String):
	if signal_name == "convo_over":
		entity.in_convo = false
