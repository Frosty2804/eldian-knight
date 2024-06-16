extends CharacterBody2D

const SPEED = 100
const DIR_RIGHT = "right"
const DIR_LEFT = "left"
const DIR_UP = "up"
const DIR_DOWN = "down"

# stores the current direction of the player
var current_dir = DIR_RIGHT
var is_moving = false

var health = Globals.player_health
var player_alive = true

var is_enemy_in_hitbox_range = false
var is_invincible = false

func _ready():
	play_anim()

func _physics_process(delta):
	if player_alive:
		if not Globals.is_player_attacking:
			# allow the player to move only if he isn't in an attack animation
			handle_movement()
			
		handle_attack()
		handle_damage()
		
		if health <= 0:
			player_alive = false
			health = 0

func handle_movement():
	var direction = get_movement_direction()
	# player is moving if his direction is not a zero vector
	is_moving = true if direction != Vector2.ZERO else false
	play_anim()
	velocity = direction * SPEED    # math hell yeah
	move_and_slide()

func get_movement_direction():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		current_dir = DIR_RIGHT
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		current_dir = DIR_LEFT
		direction.x = -1
	elif Input.is_action_pressed("ui_up"):
		current_dir = DIR_UP
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		current_dir = DIR_DOWN
		direction.y = 1
	return direction

func handle_attack():
	if Input.is_action_just_pressed("primary_action") and not Globals.is_player_attacking:
		Globals.is_player_attacking = true
		is_moving = false
		play_anim()
		$Timers/AttackCooldown.start()

func handle_damage():
	if is_enemy_in_hitbox_range and not is_invincible:
		health -= 5
		is_invincible = true
		$Timers/TakeDamageCooldown.start()

func play_anim():
	var anim : AnimatedSprite2D = $AnimatedSprite2D
	var anim_state = get_animation_state()
	
	match current_dir:
		DIR_RIGHT:
			anim.flip_h = false
			anim.play("side_" + anim_state)
		DIR_LEFT:
			anim.flip_h = true
			anim.play("side_" + anim_state)
		DIR_UP:
			anim.play("back_" + anim_state)
		DIR_DOWN:
			anim.play("front_" + anim_state)

func get_animation_state():
	if Globals.is_player_attacking:
		return "attack"
	elif is_moving:
		return "walk"
	else:
		return "idle"

func _on_player_hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
		is_enemy_in_hitbox_range = true

func _on_player_hitbox_body_exited(body):
	if body.is_in_group("Enemies"):
		is_enemy_in_hitbox_range = false

func _on_take_damage_cooldown_timeout():
	is_invincible = false

func _on_attack_cooldown_timeout():
	Globals.is_player_attacking = false
	play_anim()
