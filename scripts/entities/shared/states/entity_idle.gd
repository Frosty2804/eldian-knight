class_name EntityIdleState extends State

@export var idle_anim : String = "idle"
var stats : EntityStats
var anim_comp : EntityAnimationComponent

signal start_walking

func _ready():
	stats = owner.stats
	anim_comp = owner.anim_comp
	set_process(false)

func _enter_state():
	stats.current_speed = 0
	set_process(true)

func _exit_state():
	set_process(false)

func _process(_delta):
	anim_comp.play_anim(idle_anim)
