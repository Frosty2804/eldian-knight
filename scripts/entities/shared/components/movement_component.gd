class_name MovementComponent extends Node

@export var entity_stats : EntityStats
@export var idle_state : IdleState
@export var walk_state : WalkState

@onready var fsm : FiniteStateMachine = $"../FSM"

var is_moving = false

func _process(_delta):
	if not entity_stats.is_attacking:
		entity_stats.velocity = entity_stats.speed * entity_stats.direction
		is_moving = true if entity_stats.velocity != Vector2.ZERO else false
		if is_moving:
			fsm.change_state(walk_state)
		else:
			fsm.change_state(idle_state)
