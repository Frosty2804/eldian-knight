class_name FiniteStateMachine
extends Node

@export var current_state: State

func _ready():
	change_state(current_state)

func change_state(new_state: State):
	if current_state is State:
		current_state._exit_state()
	new_state._enter_state()
	current_state = new_state
