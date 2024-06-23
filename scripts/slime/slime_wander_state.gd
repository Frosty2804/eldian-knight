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
	wander_timer = Timer.new()
	idle_timer = Timer.new()
	wander_timer.one_shot = true
	idle_timer.one_shot = true
	timers_list.add_child(wander_timer)
	timers_list.add_child(idle_timer)

func _enter_state():
	set_physics_process(true)
	actor.play_anim("idle")

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	# check if the player is already in the detection range, if so exit wander
	var overlapping_bodies = detection_range.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("Player"):
			found_player.emit(body)
	
	if wander_timer.is_stopped() and idle_timer.is_stopped():
		update_wander_direction_and_anim()

	actor.velocity = actor.velocity.move_toward(actor.direction * wander_speed, actor.acceleration * delta)
	
	# Bounces if it collides with an object
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		actor.direction = actor.velocity.bounce(collision.get_normal()).normalized()
		actor.update_facing_direction()
		actor.velocity = actor.direction * wander_speed
	
	# play animations continously
	actor.play_anim("walk" if actor.direction != Vector2.ZERO else "idle")


func update_wander_direction_and_anim():
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
