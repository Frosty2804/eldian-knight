class_name EntityDeathState extends State

var anim_comp : EntityAnimationComponent

func _ready():
	anim_comp = owner.anim_comp
	anim_comp.anim_player.animation_finished.connect(_on_anim_finished)
	set_process(false)

func _on_anim_finished(anim_name):
	if anim_name == "death":
		owner.queue_free()

func _enter_state():
	anim_comp.play_anim("death")
	set_process(true)

func _exit_state():
	set_process(false)
