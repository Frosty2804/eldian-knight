class_name Level extends Node2D

@onready var player = $Player
@onready var cam_manager = $CamManager

func _ready():
	player.connect("zoom_into_inventory", _switch_camera)
	player.connect("zoom_out_from_inventory", _switch_camera)

func _switch_camera(cam1 : PhantomCamera2D, cam2 : PhantomCamera2D):
	cam_manager.switch_cam(cam1, cam2)
