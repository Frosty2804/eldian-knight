class_name EnemyBasicAttackState extends EntityAttackState

var rng = RandomNumberGenerator.new()
var stats : EnemyStats
var nav_agent : NavigationAgent2D
var target_pos : Vector2
var attack_speed : float

func _ready():
	super._ready()
	rng.randomize()
	stats = owner.stats
	nav_agent = owner.nav_agent
	attack_name = "attack"
	set_physics_process(false)

func _enter_state():
	super._enter_state()
	set_physics_process(true)

func _exit_state():
	set_physics_process(false)

func _physics_process(_delta):
	# making the slime jump attack towards the player
	nav_agent.target_position = target_pos
	if nav_agent.is_navigation_finished():
		return
	var next_path_position = nav_agent.get_next_path_position()
	attack_speed = rng.randf_range(stats.min_speed, stats.max_speed)
	owner.move_towards(owner.get_dir_to(next_path_position), attack_speed)

func _set_target_pos(atk_target_pos):
	self.target_pos = atk_target_pos
