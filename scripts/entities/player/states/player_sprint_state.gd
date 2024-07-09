class_name PlayerSprintState extends State

var stats : PlayerStats
var sprint_speed : float
var anim_comp : EntityAnimationComponent
var current_playback_speed : float
var new_playback_speed : float
const sprint_playback_speed = 1.5
const walk_playback_speed = 1

func _ready():
	stats = owner.stats
	sprint_speed = stats.max_speed
	anim_comp = owner.anim_comp
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)

func _exit_state():
	anim_comp.anim_player.set_speed_scale(walk_playback_speed)
	set_physics_process(false)

func _physics_process(delta):
	owner.move_towards(stats.direction)
	# Accelerate to sprint speed
	stats.current_speed = min(stats.current_speed + stats.acceleration, sprint_speed)
	current_playback_speed = anim_comp.anim_player.get_speed_scale()
	new_playback_speed = min(current_playback_speed + (sprint_playback_speed - 1.0) * delta, sprint_playback_speed)
	anim_comp.anim_player.set_speed_scale(new_playback_speed)
