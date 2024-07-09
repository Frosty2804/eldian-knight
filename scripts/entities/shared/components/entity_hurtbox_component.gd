class_name EntityHurtbox extends Area2D

@export var knockback_multiplier : float = 50.0
@export var invincible_for: float = 0.5
@export var damage_frame_duration: float = 0.1 
var stats : EntityStats
var idle_state : EntityIdleState
var hurt_state : EntityHurtState
var timer_comp : TimersComponent
var accumulated_dmg : float = 0
var knockback : Vector2 = Vector2.ZERO
var enemy_count : int = 0
var invincible_duration_timer: Timer
var damage_frame_timer: Timer

signal change_state(state: State)

func _ready():
	stats = owner.stats
	idle_state = owner.idle_state
	hurt_state = owner.hurt_state
	timer_comp = owner.timer_comp
	
	hurt_state.connect("state_over", _on_hurt_state_over)
	invincible_duration_timer = timer_comp.create_timer(true, on_invincible_duration_timer_timeout)
	damage_frame_timer = timer_comp.create_timer(true, on_damage_frame_timer_timeout)
	area_entered.connect(_on_area_entered)

func _on_hurt_state_over():
	change_state.emit(idle_state)

func on_invincible_duration_timer_timeout():
	stats.is_invincible = false

func on_damage_frame_timer_timeout():
	take_damage()
	stats.is_invincible = true
	invincible_duration_timer.start(invincible_for)

func _on_area_entered(area):
	if not area is Hitbox or stats.is_invincible or area.in_damage_frame == false:
		return
	if enemy_count == 0:
		damage_frame_timer.start(damage_frame_duration)
	accumulated_dmg += area.damage
	knockback += (owner.global_position - area.owner.global_position).normalized() * knockback_multiplier
	enemy_count += 1
	area.in_damage_frame = false

func take_damage():
	stats.health -= accumulated_dmg
	hurt_state.knockback = knockback / enemy_count
	change_state.emit(hurt_state)
	accumulated_dmg = 0
	knockback = Vector2.ZERO
	enemy_count = 0
