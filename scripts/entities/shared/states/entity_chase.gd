class_name EntityChaseState extends State

var stats : EntityStats
var target : CharacterBody2D    # to be initialized by the chase comp.
var chase_speed : float
var anim_comp : EntityAnimationComponent
var current_playback_speed : float
var new_playback_speed : float
const chase_playback_speed = 1.15
const walk_playback_speed = 1

func _ready():
	stats = owner.stats
	chase_speed = stats.max_speed
	anim_comp = owner.anim_comp
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)

func _exit_state():
	anim_comp.anim_player.set_speed_scale(walk_playback_speed)
	target = null
	set_physics_process(false)

func _physics_process(delta):
	owner.move_towards(owner.get_dir_to(target))
	# accelerate to chase speed
	stats.current_speed = min(stats.current_speed + stats.acceleration, chase_speed)
	current_playback_speed = anim_comp.anim_player.get_speed_scale()
	new_playback_speed = min(current_playback_speed + (chase_playback_speed - 1.0) * delta, chase_playback_speed)
	anim_comp.anim_player.set_speed_scale(new_playback_speed)
