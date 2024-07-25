class_name NPCInteractionComponent extends Area2D

signal change_state(next_state)

var convo_with : Entity = null
var idle_state : EntityIdleState

func _ready():
	Dialogic.signal_event.connect(_on_dialog_manager_signal_recieved)
	body_entered.connect(_in_interaction_range)
	body_exited.connect(_exit_interaction_range)
	idle_state = owner.idle_state

func _in_interaction_range(body):
	if body is Player:
		body.in_convo_range = true
		convo_with = body
		convo_with.connect("init_convo", _on_init_convo)

func _exit_interaction_range(_body):
	if convo_with != null:
		convo_with.in_convo_range = false
		convo_with.disconnect("init_convo", _on_init_convo)
		convo_with = null

func _on_init_convo():
	change_state.emit(idle_state)
	Globals.run_dialogue("reaper_intro")
	convo_with._entered_convo()

func _on_dialog_manager_signal_recieved(signal_name : String):
	if signal_name == "convo_over":
		convo_with._exited_convo()
