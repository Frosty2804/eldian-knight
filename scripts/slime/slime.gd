extends CharacterBody2D

const MAX_SPEED = 50
const acceleration = 100

@onready var fsm : FiniteStateMachine = $FSM
@onready var hostile_state = $FSM/Hostile
@onready var wander_state = $FSM/Wander

var damage_player = false
var in_attack = "none"
var facing_direction = "right"
var direction: Vector2 = Vector2.ZERO

func _ready():
	wander_state.connect("found_player", _on_found_player)
	hostile_state.connect("lost_player", _on_lost_player)

func _on_found_player(player):
	hostile_state.player = player
	fsm.change_state(hostile_state)   

func _on_lost_player():
	fsm.change_state(wander_state) 
