class_name HealthBar extends ProgressBar

@onready var damage_bar = $DamageBar
@onready var update_bar_timer = $UpdateBarTimer
@onready var hide_bar_timer = $HideBarTimer
const update_bar_after = 0.4
const hide_bar_after = 2

var health : float : set = _set_health

func _set_health(new_heath_val):
	var prev_health_val = health
	health = min(self.max_value, new_heath_val)
	if health <= 0:
		queue_free()
	self.value = health
	
	if health < max_value:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1, 0.4)
		hide_bar_timer.start(hide_bar_after)
	
	if health < prev_health_val:
		update_bar_timer.start(update_bar_after)
	else:
		damage_bar.value = health

func init_health(starting_health):
	health = starting_health
	self.max_value = health
	self.value = health
	damage_bar.value = health

func _ready():
	self.modulate.a = 0
	update_bar_timer.connect("timeout", _update_bar)
	update_bar_timer.one_shot = true
	hide_bar_timer.connect("timeout", _hide_bar)
	hide_bar_timer.one_shot = true
	
func _update_bar():
	damage_bar.value = health

func _hide_bar():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.4)
