class_name Cow extends NPC

@export var hurtbox : EntityHurtbox
@export var hurt_state : EntityHurtState

func _ready():
	super._ready()
	hurtbox.connect("change_state", _change_state)
