class_name Player extends Entity
@export var stats : PlayerStats

# components
@export var hitflash_anim_player : AnimationPlayer
@export var sprint_comp : PlayerSprintComponent
@export var attack_comp : EntityAttackComponent
@export var hurtbox : EntityHurtbox

# states
@export var sprint_state : PlayerSprintState
@export var hurt_state : EntityHurtState
@export var attack_states : Array[EntityAttackState]

func _ready():
	super._ready()
	sprint_comp.connect("switch_state", _switch_state)
	attack_comp.connect("change_state", _change_state)
	hurtbox.connect("change_state", _change_state)
	healthbar.init_health(stats.health)

func _set_health(health):
	super._set_health(health)
	stats.health = health

func _process(_delta):
	if  fsm.current_state is EntityAttackState or fsm.current_state is EntityDeathState:
		return
	
	# handling input
	if Input.is_action_just_pressed("primary_action") and attack_comp.atk_cooldown_tmr.is_stopped():
		attack_comp.attack_index = 0    # basic attack
		attack_comp.should_attack = attack_comp.attack_index > -1
	
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		dir.x = -1
	elif Input.is_action_pressed("ui_up"):
		dir.y = -1
	elif Input.is_action_pressed("ui_down"):
		dir.y = 1
	
	sprint_comp.should_sprint = dir != Vector2.ZERO and Input.is_action_pressed("ui_sprint")
	
	stats.direction = dir

func move_towards(dir : Vector2 = stats.direction, speed : float = stats.current_speed):
	update_velocity(dir, speed)
	move_and_slide()

func update_velocity(dir, speed : float):
	stats.direction = dir
	stats.current_speed = speed
	update_facing_direction()
	velocity = stats.direction * stats.current_speed

func update_facing_direction():
	if abs(stats.direction.x) > abs(stats.direction.y):
		stats.facing_direction = "right" if stats.direction.x > 0 else "left"
	else:
		stats.facing_direction = "front" if stats.direction.y > 0 else "back"
