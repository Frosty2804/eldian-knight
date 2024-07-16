class_name EntityAnimationComponent extends Node

var stats : EntityStats
var sprite : Sprite2D
var anim_player : AnimationPlayer
var hitflash_anim_player : AnimationPlayer

func _ready():
	stats = owner.stats
	sprite = owner.sprite
	anim_player = owner.anim_player
	hitflash_anim_player = owner.hitflash_anim_player

func play_anim(anim_state, play_hitflash = false):
	if anim_state == "none":
		return
	
	if anim_state == "death":
		anim_player.play("death")
		return
	
	if play_hitflash:
		hitflash_anim_player.play("hit_flash")
	
	match stats.facing_direction:
		"right":
			sprite.flip_h = false
			anim_player.play("side_" + anim_state)
		"left":
			sprite.flip_h = true
			anim_player.play("side_" + anim_state)
		"front":
			if anim_player.has_animation("front_" + anim_state):
				anim_player.play("front_" + anim_state)
			else:
				anim_player.play("side_" + anim_state)
		"back":
			if anim_player.has_animation("back_" + anim_state):
				anim_player.play("back_" + anim_state)
			else:
				anim_player.play("side_" + anim_state)
