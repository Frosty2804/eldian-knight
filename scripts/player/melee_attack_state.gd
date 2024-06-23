class_name MeleeAttackState
extends State

@export var player : CharacterBody2D
@export var hitbox : Area2D
@export var anim_player : AnimatedSprite2D

func _ready():
	hitbox.connect("body_entered", _on_hitbox_body_entered)

func _enter_state():
	Globals.is_player_attacking = true
	player.velocity = Vector2.ZERO
	player.play_anim("attack")
	anim_player.connect("animation_finished", _on_animation_finished)

func _exit_state():
	anim_player.disconnect("animation_finished", _on_animation_finished)
	Globals.is_player_attacking = false

func _on_animation_finished():
	if player.anim_state == "attack":
		state_finished.emit(player.idle_state)

func _on_hitbox_body_entered(body):
	player.anim_state = "hurt"    # breaks out of the attack animation
	state_finished.emit(player.hurt_state)
