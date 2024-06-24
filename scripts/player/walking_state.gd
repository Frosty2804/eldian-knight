class_name WalkingState
extends State

@export var player : CharacterBody2D
@export var anim_player : AnimationPlayer

signal init_attack

const sprint_playback_speed = 1.5
const walk_playback_speed = 1

func _ready():
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)

func _exit_state():
	anim_player.set_speed_scale(1)
	player.velocity = Vector2.ZERO
	set_physics_process(false)

func _physics_process(_delta):
	player.play_anim("walk")
	
	var sprinting = Input.is_action_pressed("ui_sprint")
	
	if sprinting:
		player.speed += player.acceleration 
		anim_player.set_speed_scale(sprint_playback_speed)
		if player.speed > player.max_speed:
			player.speed = player.max_speed
	else:
		player.speed -= player.deceleration
		anim_player.set_speed_scale(walk_playback_speed)
		if player.speed < player.walk_speed:
			player.speed = player.walk_speed
	
	
	player.velocity = player.speed * player.direction
	player.move_and_slide()
	
	# keep checking if player has stopped moving
	player.direction = player.get_movement_direction()
	player.is_moving = true if (player.direction != Vector2.ZERO) else false
	if not player.is_moving:
		state_finished.emit(player.idle_state)
	
	# check if the player has pressed the attack button
	if Input.is_action_just_pressed("primary_action"):
		init_attack.emit()
