class_name EntityWalkState extends State

var stats : EntityStats
var anim_comp : EntityAnimationComponent
var walk_speed : float

func _ready():
	stats = owner.stats
	anim_comp = owner.anim_comp
	walk_speed = stats.min_speed
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	anim_comp.play_anim("walk")
	owner.move_towards(stats.direction)
	# Acceleration/Deceleration
	if stats.current_speed > walk_speed:
		stats.current_speed = clamp(stats.current_speed - stats.acceleration * delta, walk_speed, stats.current_speed)
	elif stats.current_speed < walk_speed:
		stats.current_speed = clamp(stats.current_speed + stats.acceleration * delta, stats.current_speed, walk_speed)
