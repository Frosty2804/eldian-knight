class_name SlimeHostileState
extends State

@export var actor: CharacterBody2D
@export var anim_player: AnimatedSprite2D
@export var detection_range: Area2D
@export var attack_cooldown = 1.2

signal lost_player

const long_attack_range = 40
const short_attack_range = 10
const leap_speed = 40

var can_attack = true
var in_attack = "none"
var target : Vector2

var player: CharacterBody2D

var attack_cooldown_timer: Timer

func _ready():
	set_physics_process(false)
	anim_player.connect("animation_finished", _on_animation_finished)
	detection_range.connect("body_exited", _on_detection_range_body_exited)
	
	var timers_list = get_parent().get_parent().get_node("Timers")
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.one_shot = true
	timers_list.add_child(attack_cooldown_timer)
	attack_cooldown_timer.connect("timeout", _on_attack_cooldown_timeout)


func _enter_state():
	if player:
		can_attack = true
		set_physics_process(true)

func _exit_state():
	attack_cooldown_timer.stop()
	set_physics_process(false)

func _physics_process(_delta):
	var distance_to_player = actor.get_dist_to(player)
	if can_attack:
		if distance_to_player > long_attack_range and in_attack == "none":
			chase_player()
		elif distance_to_player <= short_attack_range and in_attack != "long":
			short_attack()
		elif distance_to_player <= long_attack_range and in_attack != "short":
			long_attack()
	else:
		if distance_to_player > short_attack_range:
			chase_player()
		else:
			idle()

func chase_player():
	actor.play_anim("walk")
	follow(player, actor.MAX_SPEED)

func long_attack():
	if not in_attack == "long":
		in_attack = "long"
		actor.play_anim("attack")
		target = player.global_position
	follow(target, actor.MAX_SPEED)

func follow(object, speed):
	actor.direction = actor.get_dir_to(object)
	actor.velocity = actor.velocity.move_toward(actor.direction * speed, actor.acceleration * get_process_delta_time())
	actor.update_facing_direction()
	var collision = actor.move_and_collide(actor.velocity * get_process_delta_time())
	#collision handling
	if collision and collision.get_collider() != player:
		actor.direction = actor.velocity.bounce(collision.get_normal()).normalized()
		actor.update_facing_direction()
		actor.velocity = actor.direction * speed


func short_attack():
	if in_attack != "short":
		in_attack = "short"
		actor.play_anim("attack")
	face(player)

func idle():
	actor.play_anim("idle")
	face(player)

func face(object):
	actor.direction = actor.get_dir_to(object)
	actor.update_facing_direction()
	actor.velocity = Vector2.ZERO


func _on_attack_cooldown_timeout():
	can_attack = true

func _on_animation_finished():
	if actor.anim_state == "attack":
		can_attack = false
		attack_cooldown_timer.start(attack_cooldown)
		in_attack = "none"

func _on_detection_range_body_exited(body):
	if body == player:
		player = null
		emit_signal("lost_player")
