class_name IdleState
extends State

@export var player : CharacterBody2D

signal init_attack

func _ready():
	set_process(false)

func _enter_state():
	player.play_anim("idle")
	player.velocity = Vector2.ZERO
	set_process(true)

func _exit_state():
	set_process(false)

func _process(_delta):
	# checks continously if a movement key is pressed
	player.direction = player.get_movement_direction()
	player.is_moving = true if (player.direction != Vector2.ZERO) else false
	if player.is_moving:
		state_finished.emit(player.walking_state)

	# check if player has pressed the attack button
	if Input.is_action_just_pressed("primary_action"):
		init_attack.emit()
