class_name Entity extends CharacterBody2D

# Components
@export var fsm : FSM
@export var sprite : Sprite2D
@export var healthbar : HealthBar
@export var anim_player : AnimationPlayer
@export var hitflash_anim_player : HitFlashAnimPlayer
@export var move_comp : EntityMovementComponent
@export var anim_comp : EntityAnimationComponent
@export var timer_comp : TimersComponent

# States
@export var idle_state : EntityIdleState
@export var walk_state : EntityWalkState
@export var death_state : EntityDeathState

var home_pos : Vector2
var near_level_boundary : bool = false

func _ready():
	move_comp.connect("switch_state", _switch_state)
	home_pos = self.global_position
	

func _change_state(next_state : State):
	if not fsm.current_state is EntityDeathState:
		fsm.change_state(next_state)

func _switch_state(current_state : State, next_state : State):
	if fsm.current_state == current_state and not fsm.current_state is EntityDeathState:
		fsm.change_state(next_state)

func _set_health(health):
	if health <= 0:
		health = 0
		_change_state(death_state)
	else:
		healthbar.health = health

# utlity
func get_dir_to(object) -> Vector2:
	if object is CharacterBody2D:
		return (object.global_position - self.global_position).normalized()
	elif object is Vector2:
		return (object - self.global_position).normalized()
	else:
		return Vector2.ZERO

func get_dist_to(object) -> float:
	if object is CharacterBody2D:
		return self.global_position.distance_to(object.global_position)
	elif object is Vector2:
		return self.global_position.distance_to(object)
	else:
		return 0.0 


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
