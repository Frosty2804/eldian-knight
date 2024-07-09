class_name EntityMovementComponent extends Node

var stats : EntityStats
var idle_state : EntityIdleState
var walk_state : EntityWalkState

signal switch_state(current_state : State, next_state : State)

func _ready():
	stats = owner.stats
	idle_state = owner.idle_state
	walk_state = owner.walk_state

func _process(_delta):
	if stats.direction != Vector2.ZERO:
		switch_state.emit(idle_state, walk_state)
	else:
		switch_state.emit(walk_state, idle_state)
