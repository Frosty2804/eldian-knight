extends Node2D
@onready var anim_player = $AnimationPlayer
@onready var player : Player = $Player
@onready var reaper : Reaper = $reaper
const WHITE = Color(0.980392, 0.921569, 0.843137, 1)

func _ready():
	Dialogic.signal_event.connect(_on_dialog_manager_signal_recieved)
	anim_player.play("intro_anim")
	player.sprite.frame = 56

func _on_dialog_manager_signal_recieved(signal_name : String):
	if signal_name == "player_intro_over" and player.in_convo == true:
		player.in_convo = false
		await SceneTransition.fade_to_color(1.2, WHITE)
		SceneTransition.fade_to_normal(1.2, WHITE)
		reaper.appear()

func _fade_from_black_to_normal():
	SceneTransition.fade_to_normal(1.2)

func player_intro():
	Dialogic.start("player_intro_dialogue")
	player.in_convo = true

func player_after_reaper_intro_dialogue():
	pass
