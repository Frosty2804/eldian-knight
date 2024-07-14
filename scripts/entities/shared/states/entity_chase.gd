class_name EntityChaseState extends State

var stats : EntityStats
var target : CharacterBody2D    # to be initialized by the chase comp.
var chase_speed : float
var nav_agent : NavigationAgent2D
var anim_comp : EntityAnimationComponent
var current_playback_speed : float
var new_playback_speed : float
const chase_playback_speed = 1.15
const walk_playback_speed = 1

func _ready():
	stats = owner.stats
	chase_speed = stats.max_speed
	nav_agent = owner.nav_agent
	anim_comp = owner.anim_comp
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)

func _exit_state():
	anim_comp.anim_player.set_speed_scale(walk_playback_speed)
	set_physics_process(false)

func _physics_process(delta):
	if not target:
		return
	
	anim_comp.play_anim("walk")
	nav_agent.target_position = target.global_position
	if nav_agent.is_navigation_finished():
		return
	var next_path_position = nav_agent.get_next_path_position()
	owner.move_towards(owner.get_dir_to(next_path_position))
	# accelerate
	stats.current_speed = min(stats.current_speed + stats.acceleration, chase_speed)
	current_playback_speed = anim_comp.anim_player.get_speed_scale()
	new_playback_speed = min(current_playback_speed + (chase_playback_speed - 1.0) * delta, chase_playback_speed)
	anim_comp.anim_player.set_speed_scale(new_playback_speed)
