class_name EntityAttackState extends State

var anim_comp
var attack_name : String

signal attack_over

func _ready():
	anim_comp = owner.anim_comp
	anim_comp.anim_player.connect("animation_finished", _on_atk_anim_finished)

func _enter_state():
	anim_comp.play_anim(attack_name)

func _on_atk_anim_finished(anim_name):
	if anim_name.substr(anim_name.find('_') + 1, anim_name.length()) == attack_name:
		attack_over.emit()
