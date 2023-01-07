tool
extends Position3D
class_name VirtualCamera

export(float) var priority: float = 10 setget set_priority
export(bool) var active: bool = true setget set_active

export(Vector3) var follow_offset = Vector3(0, 0, -10)

export(Vector3) var position_smoothing = Vector3(0.5, 0.5, 0.5)
export(float) var rotation_smoothing = 0.5

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	add_to_group("virtual_cameras")
	get_tree().call_group("virtual_camera_brains", "add_vcam", self)

func _exit_tree():
	get_tree().call_group("virtual_camera_brains", "remove_vcam", self)

func set_priority(x):
	if x != priority:
		priority = x
		if is_inside_tree():
			get_tree().call_group("virtual_camera_brains", "update_vcam", self)

func set_active(a):
	if a != active:
		active = a
		if is_inside_tree():
			get_tree().call_group("virtual_camera_brains", "add_vcam" if active else "remove_vcam", self)
