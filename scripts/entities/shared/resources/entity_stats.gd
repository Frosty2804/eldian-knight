class_name EntityStats extends Resource

# status values
var is_invincible : bool = false

# health
@export var health : float = 100

# movement
@export var min_speed : float = 60
@export var max_speed : float = 100
@export var acceleration : float = 75
var current_speed : float = 0
var facing_direction : String = "right"
var direction : Vector2 = Vector2.ZERO
