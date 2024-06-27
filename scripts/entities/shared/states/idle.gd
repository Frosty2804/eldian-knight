class_name IdleState extends State

@export var anim : AnimationComponent

func _ready():
	set_process(false)

func _enter_state():
	set_process(true)

func _exit_state():
	set_process(false)

func _process(_delta):
	anim.play_anim("idle")
