class_name TransitionScreen extends CanvasLayer
 
@onready var color_rect : ColorRect = $ColorRect
const BLACK =  Color(0, 0, 0, 1)

func _ready():
	color_rect.modulate.a = 0

func fade_to_color(duration : float, color : Color = BLACK):
	color_rect.color = color
	print(color)
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1, duration)
	print("true")

func fade_to_normal(duration : float, color : Color = BLACK):
	color_rect.color = color
	color_rect.modulate.a = 1
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, duration)
 
