extends CharacterBody2D

const MAX_SPEED = 50
const acceleration = 100

@onready var fsm : FiniteStateMachine = $FiniteStateMachine
@onready var hostile_state = $FiniteStateMachine/SlimeHostileState
@onready var wander_state = $FiniteStateMachine/SlimeWanderState

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

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


func create_timer(parent,is_one_shot,connect_func = null) -> Timer:
	var timer = Timer.new()
	timer.one_shot = is_one_shot
	parent.add_child(timer)
	if connect_func:
		timer.connect("timeout", connect_func)
	return timer

func play_anim(anim_state):
	if anim_state == "none":
		pass
	
	match facing_direction:
		"right":
			sprite.flip_h = false
			anim_player.play("side_" + anim_state)
		"left":
			sprite.flip_h = true
			anim_player.play("side_" + anim_state)
		"up":
			anim_player.play("back_" + anim_state)
		"down":
			anim_player.play("front_" + anim_state)


func update_facing_direction():
	if abs(direction.x) > abs(direction.y):
		facing_direction = "right" if direction.x > 0 else "left"
	else:
		facing_direction = "down" if direction.y > 0 else "up"
