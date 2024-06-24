class_name MeleeAttackState
extends State

@export var player : CharacterBody2D
@export var anim_player : AnimationPlayer

func _enter_state():
	Globals.is_player_attacking = true
	player.velocity = Vector2.ZERO
	player.play_anim("attack")
	anim_player.connect("animation_finished", _on_animation_finished)

func _exit_state():
	anim_player.disconnect("animation_finished", _on_animation_finished)
	Globals.is_player_attacking = false
	player.attack_cooldown_timer.start(player.attack_cooldown)

func _on_animation_finished(anim_name : String):
	if anim_name.substr(anim_name.find('_') + 1, anim_name.length()) == "attack":
		state_finished.emit(player.idle_state)
