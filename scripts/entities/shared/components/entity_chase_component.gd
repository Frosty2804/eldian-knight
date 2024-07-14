class_name EntityChaseComponent extends Node

var fsm : FSM
var chase_state : EntityChaseState
var idle_state : EntityIdleState
var walk_state : EntityWalkState
# these should be supplied by another component
var should_chase = false    
var target : CharacterBody2D

signal switch_state(current_state : State, next_state : State)

func _ready():
	fsm = owner.fsm
	chase_state = owner.chase_state
	idle_state = owner.idle_state
	walk_state = owner.walk_state 

func _process(_delta):
	# enter condition
	if should_chase and (fsm.current_state == idle_state or fsm.current_state == walk_state):
		chase_state.target = target
		switch_state.emit(fsm.current_state, chase_state)
	# exit condition: player escapes
	if not should_chase and fsm.current_state == chase_state:
		switch_state.emit(chase_state, walk_state)
		chase_state.target = null
		target = null
