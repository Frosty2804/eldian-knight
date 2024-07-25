class_name ReaperWeaponWieldHolsterState extends State

var anim_comp : EntityAnimationComponent
var idle_state : EntityIdleState

signal switch_state(next_state)

func _ready():
	anim_comp = owner.anim_comp
	anim_comp.anim_player.animation_finished.connect(_on_anim_finished)
	idle_state = owner.idle_state

func _on_anim_finished(_anim_name):
	switch_state.emit(owner.fsm.current_state, idle_state)

func _enter_state():
	if owner.weapon_in_hand:
		anim_comp.play_anim("weild_weapon")
	else:
		anim_comp.play_anim("holster_weapon")
