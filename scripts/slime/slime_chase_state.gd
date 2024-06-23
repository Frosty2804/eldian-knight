class_name SlimeChaseState
extends State

signal player_in_attack_range(player : CharacterBody2D)
signal lost_player

@export var actor: CharacterBody2D
@export var detection_range: Area2D

var player: CharacterBody2D = null

func _ready():
	set_physics_process(false)
	detection_range.connect("body_exited", _on_detection_range_body_exited)

func _enter_state():
	if player:
		set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	var distance_to_player = actor.get_dist_to(player)
	
	#check to see if player is ready to attack
	if distance_to_player < actor.long_attack_range:
		player_in_attack_range.emit(player)
	
	actor.play_anim("walk")
	actor.direction = actor.get_dir_to(player)
	actor.velocity = actor.velocity.move_toward(actor.direction * actor.MAX_SPEED, actor.acceleration * delta)
	actor.update_facing_direction()
	var collision = actor.move_and_collide(actor.velocity * get_process_delta_time())
	if collision:
		actor.direction = actor.velocity.bounce(collision.get_normal()).normalized()
		actor.update_facing_direction()
		actor.velocity = actor.direction * actor.MAX_SPEED/2

func _on_detection_range_body_exited(body):
	if body == player:
		player = null
		lost_player.emit()
