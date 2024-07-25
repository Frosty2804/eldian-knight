class_name LevelBoundary extends Node2D

@onready var collision_periphery = $CollisionPeriphery

func _ready():
	collision_periphery.body_entered.connect(_entered_level_boundary)
	collision_periphery.body_exited.connect(_left_level_boundary)

func _entered_level_boundary(body):
	if body is Entity:
		body.walk_state.near_level_boundary = true

func _left_level_boundary(body):
	if body is Entity:
		body.walk_state.near_level_boundary = false
