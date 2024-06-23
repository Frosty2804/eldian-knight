class_name HurtState
extends State

@export var player : CharacterBody2D
@export var hitbox : Area2D

const animation_duration = 0.15
var animation_timer : Timer

func _ready():
	set_physics_process(false)
	
	var timers_list = get_parent().get_parent().get_node("Timers")
	animation_timer = Timer.new()
	animation_timer.one_shot = true
	timers_list.add_child(animation_timer)
	animation_timer.connect("timeout", _on_animation_finished)

func _enter_state():
	set_physics_process(true)
	player.play_anim("hurt")
	

func _exit_state():
	animation_timer.stop()
	set_physics_process(false)

func _physics_process(delta):
	var overlapping_bodies = hitbox.get_overlapping_bodies()
	var total_knockback_vector = Vector2.ZERO
	var enemies_count = 0

	if animation_timer.is_stopped():
		animation_timer.start(animation_duration)

	for body in overlapping_bodies:
		if body.is_in_group("Enemies"):
			var knockback_vector = (player.global_position - body.global_position).normalized() * 25
			total_knockback_vector += knockback_vector
			enemies_count += 1
	if enemies_count > 0:
		player.velocity = total_knockback_vector / enemies_count
	player.move_and_collide(player.velocity * delta)

func _on_animation_finished():
	print("True")
	state_finished.emit(player.idle_state)
