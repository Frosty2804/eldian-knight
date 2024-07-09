class_name Enemy extends Entity
@export var stats : EnemyStats

# components
@export var detection_range : Area2D
@export var hitflash_anim_player : AnimationPlayer
@export var hostile_comp : EntityHostileComponent
@export var attack_comp : EntityAttackComponent
@export var movement_randomizer : EntityMovementRandomizer
@export var chase_comp : EntityChaseComponent
@export var hurtbox : EntityHurtbox

# states
@export var chase_state : EntityChaseState
@export var retreat_state : EntityRetreatState
@export var hurt_state : EntityHurtState
@export var attack_states : Array[EntityAttackState]

func _ready():
	super._ready()
	chase_comp.connect("switch_state", _switch_state)
	attack_comp.connect("change_state", _change_state)
	hostile_comp.connect("switch_state", _switch_state)
	hostile_comp.connect("change_state", _change_state)
	hurtbox.connect("change_state", _change_state)

func _process(_delta):
	if stats.health <= 0:
		_change_state(death_state)

func move_towards(dir = stats.direction, speed : float = stats.current_speed, anim_name = "walk", should_update_facing_dir = true):
	anim_comp.play_anim(anim_name)
	update_velocity(dir, speed, should_update_facing_dir)
	var collision = move_and_collide(velocity * get_process_delta_time())
	if collision and not collision.get_collider() is Player:
		var bounce_dir = velocity.bounce(collision.get_normal()).normalized()
		update_velocity(bounce_dir, speed / 2, should_update_facing_dir)

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
