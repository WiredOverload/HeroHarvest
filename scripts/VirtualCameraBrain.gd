extends Node
class_name VirtualCameraBrain


var vcams: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("virtual_camera_brains")
	vcams = get_tree().get_nodes_in_group("virtual_cameras")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_vcam(vcam):
	vcams.append(vcam)
