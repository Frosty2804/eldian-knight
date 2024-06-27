class_name EntityStats extends Resource

# movement
@export var max_speed = 100
@export var speed : float = 60
@export var acceleration : float = 8
var facing_direction : String = "right"
var direction : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO

# attack
var is_attacking = false
