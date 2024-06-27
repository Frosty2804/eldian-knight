class_name PlayerWalkState extends WalkState

@export var player_stats : PlayerStats

const sprint_playback_speed = 1.5
const walk_playback_speed = 1

func _physics_process(_delta):
	anim.play_anim("walk")
	if player_stats.is_sprinting:
		player_stats.speed += player_stats.acceleration 
		anim.anim_player.set_speed_scale(sprint_playback_speed)
		if player_stats.speed > player_stats.max_speed:
			player_stats.speed = player_stats.max_speed
	else:
		player_stats.speed -= player_stats.deceleration
		anim.anim_player.set_speed_scale(walk_playback_speed)
		if player_stats.speed < player_stats.walk_speed:
			player_stats.speed = player_stats.walk_speed
	entity_stats.velocity = entity_stats.speed * entity_stats.direction
	actor.velocity = entity_stats.velocity
	actor.move_and_slide()
