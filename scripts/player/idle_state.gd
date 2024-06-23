class_name IdleState
extends State

@export var player : CharacterBody2D
@export var hitbox : Area2D

func _ready():
	hitbox.connect("body_entered", _on_hitbox_body_entered)
	set_process(false)

func _enter_state():
	player.velocity = Vector2.ZERO
	set_process(true)

func _exit_state():
	set_process(false)

func _process(_delta):
	#play idle animation
	player.play_anim("idle")
	
	# checks continously if a movement key is pressed
	player.direction = player.get_movement_direction()
	player.is_moving = true if (player.direction != Vector2.ZERO) else false
	if player.is_moving:
		state_finished.emit(player.walking_state)

	# check if player has pressed the attack button
	if Input.is_action_pressed("primary_action"):
		state_finished.emit(player.melee_attack_state)

func _on_hitbox_body_entered(body):
	state_finished.emit(player.hurt_state)
