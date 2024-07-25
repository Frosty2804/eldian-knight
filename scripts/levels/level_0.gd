extends Level
@onready var anim_player = $AnimationPlayer
@onready var reaper : Reaper = $reaper
var reaper_appeared = false

func _ready():
	super._ready()
	Dialogic.signal_event.connect(_on_dialog_manager_signal_recieved)
	anim_player.play("intro_anim")
	player.sprite.frame = 56
	player.ignore_input = true

func _on_dialog_manager_signal_recieved(signal_name : String):
	if signal_name == "player_react_to_reaper":
		SceneTransition.fade_to_color(0.7, SceneTransition.WHITE, true, 0.5)
		await get_tree().create_timer(0.7).timeout
		reaper.appear()
		reaper_appeared = true
		#cam_manager.switch_cam(0, 1)
	elif signal_name == "player_intro_cutscene_dialogue_over":
		player.ignore_input = false

func _fade_from_black_to_normal():
	SceneTransition.fade_to_normal_from_color(1.2, SceneTransition.BLACK)

func player_intro():
	Globals.run_dialogue("player_intro_cutscene_dialogue")

func _process(delta):
	if reaper_appeared and (player.global_position - reaper.global_position).length() < 15:
		var tween = create_tween()
		reaper.collision_body.disabled = true
		tween.tween_property(reaper.sprite, "modulate:a", 0.3, 0.4)
	elif reaper_appeared and reaper.sprite.modulate.a != 1:
		var tween = create_tween()
		tween.tween_property(reaper.sprite, "modulate:a", 1, 0.4)
