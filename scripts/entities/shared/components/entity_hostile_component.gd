class_name EntityHostileComponent extends Node

@export var long_attack_range : float = 50
var fsm : FSM
var detection_range : Area2D
var chase_comp : EntityChaseComponent
var attack_comp : EntityAttackComponent
var retreat_state : EntityRetreatState
const retreat_distance = 20

signal switch_state(current_state : State, next_state : State)
signal change_state(next_state : State)

func _ready():
	fsm = owner.fsm
	detection_range = owner.detection_range
	chase_comp = owner.chase_comp
	attack_comp = owner.attack_comp
	retreat_state = owner.retreat_state
	
	detection_range.connect("body_entered", _on_body_entered_detection_range)
	detection_range.connect("body_exited", _on_body_exited_detection_range)
	retreat_state.connect("retreat_over", _on_retreat_over)
	
func _on_body_entered_detection_range(body):
	chase_comp.target = body
	chase_comp.should_chase = true

func _on_body_exited_detection_range(_body):
	chase_comp.should_chase = false

func _on_retreat_over():
	switch_state.emit(retreat_state, chase_comp.idle_state)

func _process(_delta):
	if not chase_comp.should_chase or fsm.current_state is EntityDeathState or fsm.current_state is EntityHurtState or fsm.current_state is EntityAttackState: 
		return
	
	var target_pos = chase_comp.target.global_position
	var dist_to_target = owner.get_dist_to(target_pos)
	if attack_comp.atk_cooldown_tmr.is_stopped() and dist_to_target <= long_attack_range:
		attack_comp.attack_index = 0   
		attack_comp.target_pos = target_pos
		attack_comp.should_attack = true
	elif not attack_comp.atk_cooldown_tmr.is_stopped() and dist_to_target <= retreat_distance and attack_comp.attack_connected:
		attack_comp.attack_connected = false
		retreat_state.target = chase_comp.target
		change_state.emit(retreat_state)
