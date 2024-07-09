class_name EntityRetreatState extends State

@export var retreat_dist : float = 40
@export var retreat_speed : float = 20
var stats : EntityStats
var fall_back_dist : float
var target : CharacterBody2D    # to be supplied by the hostile comp.
var retreat_dir : Vector2
var movement : float

signal retreat_over

func _ready():
	stats = owner.stats
	set_physics_process(false)

func _enter_state():
	fall_back_dist = retreat_dist
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	if fall_back_dist > 0 and target != null:
		retreat_dir = (owner.global_position - target.global_position).normalized()
		movement = retreat_speed * delta
		update_facing_direction()    
		owner.move_towards(retreat_dir, retreat_speed, "walk", false)    # don't use the default update direction function
		fall_back_dist -= movement
	else:
		retreat_over.emit()

func update_facing_direction():
	if abs(stats.direction.x) > abs(stats.direction.y):
		stats.facing_direction = "left" if stats.direction.x > 0 else "right"
	else:
		stats.facing_direction = "back" if stats.direction.y > 0 else "front"
