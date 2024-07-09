class_name PlayerSprintComponent extends Node

var stats : EntityStats
var walk_state : EntityWalkState
var sprint_state : PlayerSprintState
var should_sprint = false    # to be set in another component

signal switch_state(current_state : State, next_state : State)

func _ready():
	stats = owner.stats
	walk_state = owner.walk_state
	sprint_state = owner.sprint_state

func _physics_process(_delta):
	# enter condition
	if should_sprint:
		switch_state.emit(walk_state, sprint_state)
	# exit condition
	elif stats.current_speed > stats.min_speed:
		switch_state.emit(sprint_state, walk_state)
