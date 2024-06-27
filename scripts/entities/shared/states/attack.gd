class_name AttackState extends State

@export var anim : AnimationComponent

signal attack_over

func _ready():
	set_process(false)
	anim.anim_player.connect("animation_finished", _on_atk_anim_finished)

func _enter_state():
	set_process(true)

func _exit_state():
	set_process(false)

func _process(_delta):
	anim.play_anim("attack")

func _on_atk_anim_finished(anim_name):
	if anim_name.substr(anim_name.find('_') + 1, anim_name.length()) == "attack":
		attack_over.emit()
