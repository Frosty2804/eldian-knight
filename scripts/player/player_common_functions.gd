extends Node

@export var player : CharacterBody2D
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer
@export var hit_flash_anim_player : AnimationPlayer

func create_timer(parent, is_one_shot, connect_func = null) -> Timer:
	var timer = Timer.new()
	timer.one_shot = is_one_shot
	parent.add_child(timer)
	if connect_func:
		timer.connect("timeout", connect_func)
	return timer

func get_movement_direction():
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		player.facing_direction = "right"
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		player.facing_direction = "left"
		dir.x = -1
	elif Input.is_action_pressed("ui_up"):
		player.facing_direction = "up"
		dir.y = -1
	elif Input.is_action_pressed("ui_down"):
		player.facing_direction = "down"
		dir.y = 1
	return dir

func play_anim(anim_state, play_hit_flash = false):
	if anim_state == "none":
		pass
	
	if play_hit_flash:
		hit_flash_anim_player.play("hit_flash")
	
	match player.facing_direction:
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
