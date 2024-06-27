class_name WalkState extends State

@export var anim : AnimationComponent
@export var actor : CharacterBody2D
@export var entity_stats : EntityStats

func _ready():
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	anim.play_anim("walk")
	entity_stats.velocity = entity_stats.speed * entity_stats.direction
	actor.move_and_collide(entity_stats.velocity * delta)
