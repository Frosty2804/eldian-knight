class_name Hitbox extends Area2D

@export var attack_start : float
@export var attack_end : float
@export var hitbox_path : String
@export var damage : float = 5.0
var stats : EntityStats
var in_damage_frame : bool = false

signal attack_connected

func _ready():
	stats = owner.stats
	var attack_animations = ["front_attack", "side_attack", "back_attack"]
	owner.call_method_during_anim(hitbox_path, attack_start, "enable_damage_frame", [], null, attack_animations)
	owner.call_method_during_anim(hitbox_path, attack_end, "disable_damage_frame", [], null, attack_animations)

func enable_damage_frame():
	in_damage_frame = true

func disable_damage_frame():
	in_damage_frame = false

func _process(_delta):
	if owner.fsm.current_state != get_parent() or not in_damage_frame:
		disable_all_hitboxes()
		return

	for coll_shape in self.get_children():
		if stats.facing_direction == "left" and coll_shape.name == "side":
			set_active_coll_shape(coll_shape, -1)
		elif stats.facing_direction == "right" and coll_shape.name == "side":
			set_active_coll_shape(coll_shape, 1)
		elif coll_shape.name == stats.facing_direction:
			set_active_coll_shape(coll_shape, 1)
		else:
			coll_shape.set_deferred("disabled", true)

func disable_all_hitboxes():
	for coll_shape in self.get_children():
		coll_shape.set_deferred("disabled", true)

func set_active_coll_shape(coll_shape: CollisionShape2D, scale_x: int):
	coll_shape.set_deferred("disabled", false)
	coll_shape.scale.x = scale_x
