extends Node

@export var actor : CharacterBody2D
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer

func create_timer(parent,is_one_shot,connect_func = null) -> Timer:
	var timer = Timer.new()
	timer.one_shot = is_one_shot
	parent.add_child(timer)
	if connect_func:
		timer.connect("timeout", connect_func)
	return timer

func play_anim(anim_state):
	if anim_state == "none":
		pass
	
	match actor.facing_direction:
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


func update_facing_direction():
	if abs(actor.direction.x) > abs(actor.direction.y):
		actor.facing_direction = "right" if actor.direction.x > 0 else "left"
	else:
		actor.facing_direction = "down" if actor.direction.y > 0 else "up"

func call_method_during_anim(path : String, timestamp : float, method_name : String, args = [], animation = null, anim_list = null):
	if animation:
		var this_anim : Animation = anim_player.get_animation(animation)
		insert_track(this_anim, path, timestamp, method_name, args)
	elif anim_list:
		for anim in anim_list:
			var this_anim : Animation = anim_player.get_animation(anim)
			insert_track(this_anim, path, timestamp, method_name, args)
	else:
		pass

func insert_track(this_anim, path : String, timestamp : float, method_name : String, args):
	var track_index = this_anim.add_track(Animation.TYPE_METHOD)
	this_anim.track_set_path(track_index, path)
	this_anim.track_insert_key(track_index, timestamp, {
		"method": method_name,
		"args": args,
	}, 0)
