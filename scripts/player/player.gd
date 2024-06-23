extends CharacterBody2D

const walk_speed = 60
const max_speed = 100
const acceleration = 5
const deceleration = 8

@onready var fsm = $FiniteStateMachine
@onready var idle_state = $FiniteStateMachine/IdleState
@onready var walking_state = $FiniteStateMachine/WalkingState
@onready var melee_attack_state = $FiniteStateMachine/MeleeAttackState
@onready var hurt_state = $FiniteStateMachine/HurtState

var is_moving = false
var speed : float = walk_speed
var anim_state : String
var direction : Vector2 = Vector2.ZERO
var facing_direction = "right"

var health = Globals.player_health

func _ready():
	idle_state.connect("state_finished", _on_state_finished)
	walking_state.connect("state_finished", _on_state_finished)
	melee_attack_state.connect("state_finished", _on_state_finished)
	hurt_state.connect("state_finished", _on_state_finished)

func _on_state_finished(next_state):
	fsm.change_state(next_state)


func get_movement_direction():
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		facing_direction = "right"
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		facing_direction = "left"
		dir.x = -1
	elif Input.is_action_pressed("ui_up"):
		facing_direction = "up"
		dir.y = -1
	elif Input.is_action_pressed("ui_down"):
		facing_direction = "down"
		dir.y = 1
	return dir

func play_anim(anim_to_play):
	anim_state = anim_to_play
	var anim : AnimatedSprite2D = $AnimatedSprite2D
	
	if anim_state == "none":
		pass
	
	match facing_direction:
		"right":
			anim.flip_h = false
			anim.play("side_" + anim_state)
		"left":
			anim.flip_h = true
			anim.play("side_" + anim_state)
		"up":
			anim.play("back_" + anim_state)
		"down":
			anim.play("front_" + anim_state)
