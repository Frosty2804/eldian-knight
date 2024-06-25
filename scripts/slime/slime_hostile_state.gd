class_name HostileState
extends State

@export var actor: CharacterBody2D
@export var anim_player: AnimationPlayer
@export var detection_range: Area2D
@export var comm_funcs: Node

signal lost_player

const attack_cooldown = 1.2
const long_attack_range = 40
const short_attack_range = 15
const leap_speed = 40

var can_attack = true
var target : Vector2

var player: CharacterBody2D

var attack_cooldown_timer: Timer

func _ready():
	set_physics_process(false)
	anim_player.connect("animation_finished", _on_animation_finished)
	detection_range.connect("body_exited", _on_detection_range_body_exited)
	
	var timers_list = get_parent().get_parent().get_node("Timers")
	attack_cooldown_timer = comm_funcs.create_timer(timers_list, true, _on_attack_cooldown_timeout)
	
	# connecting the 5th frame of the attack animation, to the 'damage_player' function
	var attack_animations = ["front_attack", "side_attack", "back_attack"]
	comm_funcs.call_method_during_anim("FSM/Hostile", 0.5, "damage_player", [], null, attack_animations )


func _enter_state():
	if player:
		can_attack = true
		set_physics_process(true)

func _exit_state():
	attack_cooldown_timer.stop()
	set_physics_process(false)

func _physics_process(_delta):
	var distance_to_player = get_dist_to(player)
	if can_attack:
		if distance_to_player > long_attack_range and actor.in_attack == "none":
			chase_player()
		elif distance_to_player <= short_attack_range and actor.in_attack != "long":
			short_attack()
		elif distance_to_player <= long_attack_range and actor.in_attack != "short":
			long_attack()
	else:
		if distance_to_player > short_attack_range:
			chase_player()
		else:
			idle()

func chase_player():
	comm_funcs.play_anim("walk")
	follow(player, actor.MAX_SPEED)

func long_attack():
	if not actor.in_attack == "long":
		actor.in_attack = "long"
		comm_funcs.play_anim("attack")
		target = player.global_position
	follow(target, actor.MAX_SPEED)

func follow(object, speed):
	actor.direction = get_dir_to(object)
	actor.velocity = actor.velocity.move_toward(actor.direction * speed, actor.acceleration * get_process_delta_time())
	comm_funcs.update_facing_direction()
	var collision = actor.move_and_collide(actor.velocity * get_process_delta_time())
	#collision handling
	if collision and collision.get_collider() != player:
		actor.direction = actor.velocity.bounce(collision.get_normal()).normalized()
		comm_funcs.update_facing_direction()
		actor.velocity = actor.direction * speed


func short_attack():
	if not actor.in_attack == "short":
		actor.in_attack = "short"
		comm_funcs.play_anim("attack")
	face(player)

func idle():
	comm_funcs.play_anim("idle")
	face(player)

func face(object):
	actor.direction = get_dir_to(object)
	comm_funcs.update_facing_direction()
	actor.velocity = Vector2.ZERO


func get_dir_to(object) -> Vector2:
	if object is CharacterBody2D:
		return (object.global_position - actor.global_position).normalized()
	elif object is Vector2:
		return (object - actor.global_position).normalized()
	else:
		return Vector2.ZERO

func get_dist_to(object) -> float:
	if object is CharacterBody2D:
		return actor.global_position.distance_to(object.global_position)
	elif object is Vector2:
		return actor.global_position.distance_to(object)
	else:
		return 0.0 


func _on_attack_cooldown_timeout():
	can_attack = true

func _on_animation_finished(anim_name : String):
	if anim_name.substr(anim_name.find('_') + 1, anim_name.length()) == "attack":
		can_attack = false
		attack_cooldown_timer.start(attack_cooldown)
		actor.in_attack = "none"
		actor.damage_player = false

func _on_detection_range_body_exited(body):
	if body == player:
		player = null
		emit_signal("lost_player")

# hurting player
func damage_player():
	actor.damage_player = true
