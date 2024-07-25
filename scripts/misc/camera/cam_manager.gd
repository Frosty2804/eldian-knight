class_name CamManager extends Node

@export var cam_list : Array[PhantomCamera2D]

#func switch_cam(cam1_index : int, cam2_index : int, follow_target = null):
	#var cam1 = cam_list[cam1_index]
	#var cam2 = cam_list[cam2_index]
	#cam1.set_priority(0)
	#cam2.set_priority(1)
	#follow_target = follow_target if follow_target != null else cam1.follow_target
	#cam2.set_follow_target(follow_target)

func switch_cam(cam1 : PhantomCamera2D, cam2 : PhantomCamera2D, follow_target = null):
	cam1.set_priority(0)
	cam2.set_priority(1)
	follow_target = follow_target if follow_target != null else cam1.follow_target
	cam2.set_follow_target(follow_target)
