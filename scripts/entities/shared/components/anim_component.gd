class_name AnimationComponent extends Node

@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer
@export var entity_stats : EntityStats

func play_anim(anim_state):
	if anim_state == "none":
		pass
	
	match entity_stats.facing_direction:
		"right":
			sprite.flip_h = false
			anim_player.play("side_" + anim_state)
		"left":
			sprite.flip_h = true
			anim_player.play("side_" + anim_state)
		"up":
			anim_player.play("back_" + anim_state)
		"down":
			anim_player.play("front_" + anim_state)
