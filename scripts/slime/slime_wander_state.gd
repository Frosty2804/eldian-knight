extends State
class_name SlimeWanderState

signal found_player(player: CharacterBody2D)

@export var actor: CharacterBody2D
@export var detection_range: Area2D

@export var wander_speed: float = 20
@export var walk_for_time: float = 2.0
@export var idle_for_time: float = 1.0

var wander_timer: Timer
var idle_timer: Timer

func _ready():
	set_physics_process(false)
	detection_range.connect("body_entered", _on_detection_range_body_entered)
	
	# Creating Timers, and adding them to the Node2D "Timers"
	var timers_list = get_parent().get_parent().get_node("Timers")
	wander_timer = actor.create_timer(timers_list, true)
	idle_timer = actor.create_timer(timers_list, true)

func _enter_state():
	actor.velocity = Vector2.ZERO
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	# play animations continously 
	actor.play_anim("walk" if actor.direction != Vector2.ZERO else "idle")
	
	# check if the player is already in the detection range, if so exit wander
	var overlapping_bodies = detection_range.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("Player"):
			found_player.emit(body)
	
	# randomizes velocity
	if wander_timer.is_stopped() and idle_timer.is_stopped():
		update_wander_direction()
	actor.velocity = actor.velocity.move_toward(actor.direction * wander_speed, actor.acceleration * delta)
	
	# Bounces if it collides with an object
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		actor.direction = actor.velocity.bounce(collision.get_normal()).normalized()
		actor.update_facing_direction()
		actor.velocity = actor.direction * wander_speed


func update_wander_direction():
	if randi() % 2 == 0:
		actor.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		#update the direction the enemy is facing only if some movement is detected
		actor.update_facing_direction()
		wander_timer.start(walk_for_time)
	else:
		actor.direction = Vector2.ZERO
		idle_timer.start(idle_for_time)


func _on_detection_range_body_entered(body):
	if body.is_in_group("Player"):
		found_player.emit(body)
