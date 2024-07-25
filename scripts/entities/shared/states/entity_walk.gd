class_name EntityWalkState extends State

var stats : EntityStats
var anim_comp : EntityAnimationComponent
var walk_speed : float
var anim_to_play : String = "walk"
var near_level_boundary = false

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
	anim_to_play = "walk"
	
	# fix for if an entity is near the level boundary
	if near_level_boundary:
		for collision_index in owner.get_slide_collision_count():
			var collision = owner.get_slide_collision(collision_index)
			if collision.get_collider().get_parent() is LevelBoundary:
				var entity_direction = owner.velocity.normalized()
				var collision_direction = (collision.get_position() - global_position).normalized()
				var angle_degrees = rad_to_deg(entity_direction.angle_to(collision_direction))
				if abs(angle_degrees) <= 10:
					anim_to_play = "idle"
					break
	
	anim_comp.play_anim(anim_to_play)
	owner.move_towards(stats.direction)
	# Acceleration/Deceleration
	if stats.current_speed > walk_speed:
		stats.current_speed = clamp(stats.current_speed - stats.acceleration * delta, walk_speed, stats.current_speed)
	elif stats.current_speed < walk_speed:
		stats.current_speed = clamp(stats.current_speed + stats.acceleration * delta, stats.current_speed, walk_speed)
