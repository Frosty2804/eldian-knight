class_name NPC extends Entity

@export var stats : NPCStats

func _ready():
	super._ready()
	_change_state(idle_state)
	healthbar.init_health(stats.health)

func _set_health(health):
	super._set_health(health)
	stats.health = health

func move_towards(dir = stats.direction, speed : float = stats.current_speed, should_update_facing_dir = true):
	update_velocity(dir, speed, should_update_facing_dir)
	#move_and_collide(velocity * get_process_delta_time())
	move_and_slide()

func update_velocity(dir, speed : float, should_update_facing_dir):
	stats.direction = dir
	stats.current_speed = speed
	if should_update_facing_dir:
		update_facing_direction()
	velocity = velocity.move_toward(stats.direction * stats.current_speed, stats.acceleration * get_process_delta_time())

func update_facing_direction():
	if abs(stats.direction.x) > abs(stats.direction.y):
		stats.facing_direction = "right" if stats.direction.x > 0 else "left"
	else:
		stats.facing_direction = "front" if stats.direction.y > 0 else "back"
