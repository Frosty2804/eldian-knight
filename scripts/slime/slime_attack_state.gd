class_name SlimeAttackState
extends State

@export var actor: CharacterBody2D
@export var anim_player: AnimatedSprite2D
@export var detection_range: Area2D
@export var attack_cooldown = 1

signal lost_player
signal chase_player

const short_attack_range = 10
const leap_speed = 40

var target_initialized = false
var can_attack = true
var in_attack = "none"
var begin_chasing_player : bool

var player: CharacterBody2D

var attack_cooldown_timer: Timer

func _ready():
	set_physics_process(false)
	anim_player.connect("animation_finished", _on_animation_finished)
	detection_range.connect("body_exited", _on_detection_range_body_exited)
	
	var timers_list = get_parent().get_parent().get_node("Timers")
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.connect("timeout", _on_attack_cooldown_timeout)
	timers_list.add_child(attack_cooldown_timer)


func _enter_state():
	if player:
		can_attack = true
		target_initialized = false
		begin_chasing_player = false
		set_physics_process(true)

func _exit_state():
	attack_cooldown_timer.stop()
	set_physics_process(false)

func _physics_process(delta):
	if begin_chasing_player:
		chase_player.emit()
	
	var distance_to_player = actor.get_dist_to(player)
	if distance_to_player <= short_attack_range:
		if can_attack and in_attack != "long":
			in_attack = "short"
			actor.play_anim("attack")
		else:
			actor.play_anim("idle")
		actor.direction = actor.get_dir_to(player)
		actor.update_facing_direction()
		actor.velocity = Vector2.ZERO
	
	elif distance_to_player <= actor.long_attack_range:
		if can_attack and in_attack != "short":
			in_attack = "long"
			actor.play_anim("attack")
			var target : Vector2
			if not target_initialized:
				target = player.global_position
				target_initialized = true 
			move_towards(target)
			actor.move_and_collide(actor.velocity * delta)
		else:
			begin_chasing_player = true
	
	else:
		begin_chasing_player = true


func move_towards(target : Vector2):
	actor.direction = actor.get_dir_to(target)
	actor.velocity = actor.velocity.move_toward(actor.direction * leap_speed, actor.acceleration * get_process_delta_time())
	actor.update_facing_direction()

func _on_attack_cooldown_timeout():
	print("WOrking")
	can_attack = true

func _on_animation_finished():
	if actor.anim_state == "attack":
		can_attack = false
		target_initialized = false
		attack_cooldown_timer.start(attack_cooldown)
		in_attack = "none"

func _on_detection_range_body_exited(body):
	if body == player:
		player = null
		lost_player.emit()
