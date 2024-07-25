class_name Player extends Entity
@export var stats : PlayerStats

signal zoom_into_inventory(player_cam : PhantomCamera2D, inventory_cam : PhantomCamera2D)
signal zoom_out_from_inventory(inventory_cam : PhantomCamera2D, player_cam : PhantomCamera2D)

# components
@export var sprint_comp : PlayerSprintComponent
@export var attack_comp : EntityAttackComponent
@export var hurtbox : EntityHurtbox
@export var inventory : Inventory

# states
@export var sprint_state : PlayerSprintState
@export var hurt_state : EntityHurtState
@export var attack_states : Array[EntityAttackState]

# cameras
@export var player_cam : PhantomCamera2D
@export var inventory_cam : PhantomCamera2D

@export var sprint_cooldown_time : float = 2.0
var sprint_cooldown_timer : Timer

signal init_convo
var in_convo_range = false
var ignore_input = false

func player_init_state():
	_change_state(idle_state)

func _entered_convo():
	_change_state(idle_state)
	ignore_input = true

func _exited_convo():
	ignore_input = false

func get_up():
	anim_comp.anim_player.play_backwards("death")

func _ready():
	super._ready()
	sprint_comp.connect("switch_state", _switch_state)
	attack_comp.connect("change_state", _change_state)
	hurtbox.connect("change_state", _change_state)
	healthbar.init_health(stats.health)
	sprint_cooldown_timer = timer_comp.create_timer(true)

func _set_health(health):
	super._set_health(health)
	stats.health = health

func _process(_delta):
	if ignore_input or fsm.current_state is EntityAttackState or fsm.current_state is EntityHurtState or fsm.current_state is EntityDeathState:
		return
	
	# if player collides while sprinting, knock him back
	for collision_index in get_slide_collision_count():
		var collision = get_slide_collision(collision_index)
		if fsm.current_state is PlayerSprintState:
			var knockback = (global_position - collision.get_position()).normalized() * 40
			hurt_state.play_hitflash = false
			hurt_state.knockback = knockback
			_change_state(hurt_state)
			sprint_cooldown_timer.start(sprint_cooldown_time)
			break

	# handling input
	if Input.is_action_just_pressed("primary_action") and in_convo_range:
		init_convo.emit()
		return
	elif Input.is_action_just_pressed("primary_action") and attack_comp.atk_cooldown_tmr.is_stopped():
		attack_comp.attack_index = 0    # basic attack
		attack_comp.should_attack = attack_comp.attack_index > -1
		return
	
	if Input.is_action_just_pressed("toggle_inventory") and inventory.is_open == false:
		inventory.open_inventory()
		zoom_into_inventory.emit(player_cam, inventory_cam)
	elif Input.is_action_just_pressed("toggle_inventory") and inventory.is_open == true:
		inventory.close_inventory()
		zoom_out_from_inventory.emit(inventory_cam, player_cam)
	
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		dir.x = -1
	elif Input.is_action_pressed("ui_up"):
		dir.y = -1
	elif Input.is_action_pressed("ui_down"):
		dir.y = 1
	sprint_comp.should_sprint = dir != Vector2.ZERO and Input.is_action_pressed("ui_sprint") and sprint_cooldown_timer.is_stopped()
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
