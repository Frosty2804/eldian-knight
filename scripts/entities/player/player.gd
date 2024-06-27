extends CharacterBody2D

#@onready var animation_component = $AnimationComponent
#@onready var movement_component = $MovementComponent
#@onready var fsm = $FSM
#@onready var idle_state = $FSM/IdleState
#
#
#func _ready():
	## anim component dependencies
	#animation_component.facing_direction = movement_component.facing_direction
	#
	## movement component dependencies
	#movement_component.fsm = fsm
	#movement_component.idle_state = idle_state
	#
