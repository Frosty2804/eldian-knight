extends CharacterBody2D

const walk_speed = 60
const max_speed = 100
const acceleration = 5
const deceleration = 8
const attack_cooldown = 0.4
const invincibility_cooldown = 1

@onready var common_funcs = $PlayerCommonFunctions
@onready var fsm : FiniteStateMachine = $FSM
@onready var idle_state = $FSM/Idle
@onready var walking_state = $FSM/Walking
@onready var melee_attack_state = $FSM/MeleeAttack
@onready var hurt_state = $FSM/Hurt

@onready var timers_list = $Timers
@onready var hitbox = $PlayerHitbox

var is_invincible = false
var enemies_in_hitbox = false
var can_attack = true
var is_moving = false
var speed : float = walk_speed
var direction : Vector2 = Vector2.ZERO
var facing_direction = "right"

var health = Globals.player_health

var attack_cooldown_timer : Timer
var invincibility_timer : Timer 

func _ready():
	idle_state.connect("state_finished", _on_state_finished)
	walking_state.connect("state_finished", _on_state_finished)
	melee_attack_state.connect("state_finished", _on_state_finished)
	hurt_state.connect("state_finished", _on_state_finished)
	
	idle_state.connect("init_attack", _start_attack)
	walking_state.connect("init_attack", _start_attack)
	
	hitbox.connect("body_entered", has_body_entered_hitbox)
	
	# attack cooldown timer
	attack_cooldown_timer = common_funcs.create_timer(timers_list, true, _on_attack_cooldown_timeout)
	invincibility_timer = common_funcs.create_timer(timers_list, true, _on_invincibility_timeout)


# state change logic

# general state change function
func _on_state_finished(next_state : State):
	fsm.change_state(next_state)

# transition to attack state
func _start_attack():
	if can_attack:
		fsm.change_state(melee_attack_state)
		can_attack = false

func _on_attack_cooldown_timeout():
	# timer started in the melee_attack_state
	can_attack = true

# transition to hurt state
func _process(_delta):
	if not is_invincible:
		var overlapping_bodies = hitbox.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.damage_player and fsm.current_state != hurt_state:
				fsm.change_state(hurt_state)

func has_body_entered_hitbox(body):
	if not is_invincible and body.damage_player and fsm.current_state != hurt_state:
			fsm.change_state(hurt_state)

func _on_invincibility_timeout():
	# timer started in the hurt_state
	is_invincible = false
