class_name EntityAttackComponent extends Node

@export var atk_cooldown : float = 0.5
var fsm : FSM
var idle_state : EntityIdleState
var attack_states : Array[EntityAttackState]
var timer_comp : TimersComponent
var atk_cooldown_tmr : Timer
# the following to be set by another component
var should_attack = false    
var current_attack_state : State
var attack_index : int
var target_pos : Vector2

signal change_state(next_state : State)

func _ready():
	fsm = owner.fsm
	idle_state = owner.idle_state
	attack_states = owner.attack_states
	timer_comp = owner.timer_comp
	
	atk_cooldown_tmr = timer_comp.create_timer(true)
	for attack_state in attack_states:
		attack_state.connect("attack_over", _on_attack_over)

func _physics_process(_delta):
	# Enter condition
	if should_attack:
		current_attack_state = attack_states[attack_index]
		if target_pos != null and current_attack_state.has_method("_set_target_pos"):
			current_attack_state._set_target_pos(target_pos)
		change_state.emit(current_attack_state)
		should_attack = false  
		attack_index = -1  

# exit condition
func _on_attack_over():
	atk_cooldown_tmr.start(atk_cooldown)
	change_state.emit(idle_state)
