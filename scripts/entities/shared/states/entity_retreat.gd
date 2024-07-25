class_name EntityRetreatState extends State

@export var retreat_dist : float = 50
@export var retreat_speed : float = 25
var stats : EntityStats
var anim_comp : EntityAnimationComponent
var nav_agent : NavigationAgent2D
var target : CharacterBody2D  # to be supplied by the hostile comp.
var next_path_position : Vector2

signal retreat_over

func _ready():
	stats = owner.stats
	anim_comp = owner.anim_comp
	nav_agent = owner.nav_agent
	set_physics_process(false)

func _enter_state():
	var opp_target_dir = -(owner.get_dir_to(target))
	nav_agent.target_position = owner.global_position + (opp_target_dir * retreat_dist)
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(_delta):
	anim_comp.play_anim("walk")
	if nav_agent.is_navigation_finished():
		retreat_over.emit()
		return
	next_path_position = nav_agent.get_next_path_position()
	owner.move_towards(owner.get_dir_to(next_path_position), retreat_speed, false)
	update_facing_direction()

func update_facing_direction():
	if abs(stats.direction.x) > abs(stats.direction.y):
		stats.facing_direction = "left" if stats.direction.x > 0 else "right"
	else:
		stats.facing_direction = "back" if stats.direction.y > 0 else "front"
