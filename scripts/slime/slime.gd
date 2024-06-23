extends CharacterBody2D

const MAX_SPEED = 50
const acceleration = 100

var facing_direction = "right"
var direction: Vector2 = Vector2.ZERO
var anim_state : String

@onready var fsm : FiniteStateMachine = $FiniteStateMachine
@onready var hostile_state = $FiniteStateMachine/SlimeHostileState
@onready var wander_state = $FiniteStateMachine/SlimeWanderState


func _ready():
	wander_state.connect("found_player", _on_found_player)
	hostile_state.connect("lost_player", _on_lost_player)

func _on_found_player(player):
	hostile_state.player = player
	fsm.change_state(hostile_state)   

func _on_lost_player():
	fsm.change_state(wander_state) 

func get_dir_to(object) -> Vector2:
	if object is CharacterBody2D:
		return (object.global_position - self.global_position).normalized()
	elif object is Vector2:
		return (object - self.global_position).normalized()
	else:
		return Vector2.ZERO

func get_dist_to(object) -> float:
	if object is CharacterBody2D:
		return self.global_position.distance_to(object.global_position)
	elif object is Vector2:
		return self.global_position.distance_to(object)
	else:
		return 0.0 

func play_anim(anim_to_play):
	anim_state = anim_to_play
	var anim : AnimatedSprite2D = $AnimatedSprite2D
	
	match facing_direction:
		"right":
			anim.flip_h = false
			anim.play("side_" + anim_state)
		"left":
			anim.flip_h = true
			anim.play("side_" + anim_state)
		"up":
			anim.play("back_" + anim_state)
		"down":
			anim.play("front_" + anim_state)


func update_facing_direction():
	if abs(direction.x) > abs(direction.y):
		facing_direction = "right" if direction.x > 0 else "left"
	else:
		facing_direction = "down" if direction.y > 0 else "up"
