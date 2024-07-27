class_name TransitionScreen extends CanvasLayer
 
@onready var color_rect : ColorRect = $ColorRect
const BLACK =  Color(0, 0, 0, 1)
const WHITE = Color(0.980392, 0.921569, 0.843137, 0.7)

func _ready():
	color_rect.modulate.a = 0

func fade_to_color(duration : float, color : Color = BLACK, fade_to_normal = false, fade_to_normal_duration = 0.0):
	color_rect.color = color
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(color_rect, "modulate:a", 1, duration).from(0)
	if fade_to_normal:
		tween.tween_property(color_rect, "modulate:a", 0, fade_to_normal_duration).from(1)

func fade_to_normal_from_color(duration : float, color : Color = BLACK):
	color_rect.color = color
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, duration)

func inventory_fade():
	color_rect.color = BLACK
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.5, 0.5).from(0)
