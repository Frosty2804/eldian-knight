class_name HurtState
extends State

@export var player : CharacterBody2D
@export var hitbox : Area2D

const animation_duration = 0.25
var animation_timer : Timer

func _ready():
	set_physics_process(false)
	
	var timers_list = get_parent().get_parent().get_node("Timers")
	animation_timer = player.create_timer(timers_list, true, _on_animation_finished)

func _enter_state():
	set_physics_process(true)
	animation_timer.start(animation_duration)
	
func _exit_state():
	animation_timer.stop()
	player.is_invincible = true
	player.invincibility_timer.start(player.invincibility_cooldown)
	set_physics_process(false)

func _physics_process(delta):
	#playing the animation
	player.play_anim("hurt")
	
	var overlapping_bodies = hitbox.get_overlapping_bodies()
	var total_knockback_vector = Vector2.ZERO
	var enemies_count = 0

	for body in overlapping_bodies:
		if body.in_attack != "none":
			var knockback_vector = (player.global_position - body.global_position).normalized() * 25
			total_knockback_vector += knockback_vector
			enemies_count += 1
	
	if enemies_count > 0:
		player.velocity = total_knockback_vector / enemies_count
	player.move_and_collide(player.velocity * delta)

func _on_animation_finished():
	state_finished.emit(player.idle_state)
