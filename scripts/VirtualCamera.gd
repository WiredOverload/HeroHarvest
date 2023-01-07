extends Spatial
class_name VirtualCamera

export(float) var priority: float = 10
export(bool) var active: bool = true



# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("virtual_cameras")
	get_tree().call_group("virtual_camera_brains", "add_vcam", self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
