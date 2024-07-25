class_name EntityHurtState extends State

var anim_comp : EntityAnimationComponent
var timer_comp : TimersComponent
var animation_timer : Timer
const animation_duration = 0.25
# has to be set by other components
var knockback : Vector2 = Vector2.ZERO
var play_hitflash : bool = false

signal state_over()

func _ready():
	anim_comp = owner.anim_comp
	timer_comp = owner.timer_comp
	animation_timer = timer_comp.create_timer(true, _on_animation_finished)
	set_physics_process(false)

func _enter_state():
	anim_comp.play_anim("hurt", play_hitflash)
	animation_timer.start(animation_duration)
	set_physics_process(true)
	
func _exit_state():
	knockback = Vector2.ZERO
	animation_timer.stop()
	set_physics_process(false)

func _physics_process(_delta):
	owner.velocity = knockback
	owner.move_and_slide()

func _on_animation_finished():
	state_over.emit()
