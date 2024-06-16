extends CharacterBody2D

var speed = 50
var is_chasing: bool = false
var player: CharacterBody2D = null

var health = 100
var is_entity_in_hitbox_range = false
var is_invincible = false

func _ready():
	$AnimatedSprite2D.play("side_idle")

func _physics_process(delta):
	damage_handler()

	if health <= 0:
		queue_free()

	if is_chasing:
		chase_player(delta)
	else:
		face_player()

func _on_detection_range_body_entered(body):
	player = body
	is_chasing = true

func _on_detection_range_body_exited(_body):
	player = null
	is_chasing = false

func _on_slime_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		is_entity_in_hitbox_range = true

func _on_slime_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		is_entity_in_hitbox_range = false

func _on_take_damage_cooldown_timeout():
	is_invincible = false

func damage_handler():
	if is_entity_in_hitbox_range and Globals.is_player_attacking and not is_invincible:
		health -= 20
		is_invincible = true
		$Timers/TakeDamageCooldown.start()
		if health <= 0:
			$AnimatedSprite2D.play("death")
			queue_free()

func chase_player(delta):
	var dir = (player.position - position).normalized()
	position += dir * speed * delta
	if abs(dir.x) > abs(dir.y):
		$AnimatedSprite2D.play("side_walk")
		$AnimatedSprite2D.flip_h = dir.x < 0
	else:
		if dir.y > 0:
			$AnimatedSprite2D.play("front_walk")
		else:
			$AnimatedSprite2D.play("back_walk")
	move_and_collide(Vector2(0, 0))

func face_player():
	if player != null:
		var dir = (player.position - position).normalized()
		if abs(dir.x) > abs(dir.y):
			$AnimatedSprite2D.play("side_idle")
			$AnimatedSprite2D.flip_h = dir.x < 0
		else:
			if dir.y > 0:
				$AnimatedSprite2D.play("front_idle")
			else:
				$AnimatedSprite2D.play("back_idle")
