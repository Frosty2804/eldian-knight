class_name AttackComponent extends Node

@export var entity_stats : EntityStats
@export var attack_state : AttackState

@onready var fsm : FiniteStateMachine = $"../FSM"

func _ready():
	attack_state.connect("attack_over", _on_attack_over)

func _process(_delta):
	if entity_stats.is_attacking:
		fsm.change_state(attack_state)

func _on_attack_over():
	entity_stats.is_attacking = false
