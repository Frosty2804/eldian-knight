class_name EntityMovementRandomizer extends Node

@export var walk_for_time: float = 2.0
@export var idle_for_time: float = 1.0
var stats : EntityStats
var timer_comp : TimersComponent
var wander_timer : Timer
var idle_timer : Timer

func _ready():
	stats = owner.stats
	timer_comp = owner.timer_comp
	wander_timer = timer_comp.create_timer(true)
	idle_timer = timer_comp.create_timer(true)

func _process(_delta):
	if wander_timer.is_stopped() and idle_timer.is_stopped():
		if randi() % 2 == 0:
			stats.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			wander_timer.start(walk_for_time)
		else:
			stats.direction = Vector2.ZERO
			idle_timer.start(idle_for_time)
