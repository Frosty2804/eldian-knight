class_name EntityDeathState extends State

var anim_comp : EntityAnimationComponent
var healthbar

func _ready():
	anim_comp = owner.anim_comp
	anim_comp.anim_player.animation_finished.connect(_on_anim_finished)
	healthbar = owner.healthbar

func _on_anim_finished(anim_name):
	if anim_name == "death":
		owner.queue_free()

func _enter_state():
	healthbar.health = 0
	anim_comp.play_anim("death")
