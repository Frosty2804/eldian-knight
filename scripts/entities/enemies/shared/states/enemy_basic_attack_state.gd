class_name EnemyBasicAttackState extends EntityAttackState

var rng = RandomNumberGenerator.new()
var stats : EnemyStats
var target_pos : Vector2
var attack_speed : float

func _ready():
	super._ready()
	rng.randomize()
	stats = owner.stats
	attack_name = "attack"

func _process(delta):
	super._process(delta)
	attack_speed = rng.randf_range(stats.min_speed, stats.max_speed)
	owner.move_towards(owner.get_dir_to(target_pos), attack_speed, "attack")

func _exit_state():
	super._exit_state()

func _set_target_pos(atk_target_pos):
	self.target_pos = atk_target_pos
