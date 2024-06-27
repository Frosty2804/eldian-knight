class_name InputHandler extends Node

@export var player_stats : PlayerStats

var dir : Vector2

func _process(_delta):
	# movement
	dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		player_stats.facing_direction = "right"
		dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		player_stats.facing_direction = "left"
		dir.x = -1
	elif Input.is_action_pressed("ui_up"):
		player_stats.facing_direction = "up"
		dir.y = -1
	elif Input.is_action_pressed("ui_down"):
		player_stats.facing_direction = "down"
		dir.y = 1
		
	player_stats.direction = dir
	
	# sprinting
	player_stats.is_sprinting = Input.is_action_pressed("ui_sprint")
	
	# attacking
	if Input.is_action_just_pressed("primary_action"):
		player_stats.is_attacking = true
