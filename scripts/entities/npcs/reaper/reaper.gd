class_name Reaper extends NPC

@export var wield_holster_weapon_state : ReaperWeaponWieldHolsterState
@export var interaction_comp : NPCInteractionComponent
var weapon_in_hand = false

func _ready():
	interaction_comp.connect("change_state", _change_state)
	wield_holster_weapon_state.switch_state.connect(_switch_state)
	stats.facing_direction = "left"
	sprite.modulate.a = 0

func appear():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.4)
	_change_state(wield_holster_weapon_state)
