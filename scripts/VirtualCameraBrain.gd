tool
extends Node
class_name VirtualCameraBrain

export(NodePath) var camera_path: NodePath = ""
onready var camera = get_node(camera_path) if camera_path != "" else null

export(bool) var run_in_editor: bool = false

var vcams: Array = []

var target: Spatial = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("virtual_camera_brains")
	vcams = get_tree().get_nodes_in_group("virtual_cameras")
	vcams.sort_custom(self, "vcam_comparator")
	if camera == null:
		camera = get_viewport().get_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Engine.editor_hint && !run_in_editor:
		return
	
	if vcams.size() == 0:
		target = null
		return
	
	var priority = NAN
	var active_cams = []
	for i in range(0, vcams.size()):
		if vcams[i].active:
			if is_nan(priority):
				priority = vcams[i].priority
			if vcams[i].priority < priority:
				break
			active_cams.append(vcams[i])
	
	if target != null && (!target.active || active_cams.find(target) == -1):
		target = null
	
	var target_dist: float = INF
	if target != null:
		target_dist = camera.global_translation.distance_squared_to(target.global_translation)
	
	for i in range(0, active_cams.size()):
		if active_cams[i] == target:
			continue
		var dist = camera.global_translation.distance_squared_to(active_cams[i].global_translation)
		if dist < target_dist:
			target_dist = dist
			target = active_cams[i]
	
	# update
	
	if target == null:
		return
	
	var desired_position = target.global_translation + target.global_transform.basis * target.follow_offset
	var travel = desired_position - camera.global_translation
	var position_lerp_t = Vector3(
		_calc_lerp_t(target.position_smoothing.x, delta),
		_calc_lerp_t(target.position_smoothing.y, delta),
		_calc_lerp_t(target.position_smoothing.z, delta))
	camera.global_translate(travel * position_lerp_t)
	
	var target_rot = Quat(target.global_transform.basis)
	var rotation_lerp_t = _calc_lerp_t(target.rotation_smoothing, delta)
	camera.global_transform.basis = Basis(Quat(camera.global_transform.basis).slerp(target_rot, rotation_lerp_t))

static func _calc_lerp_t(smoothing, delta):
	return 1.0 - pow(smoothing, delta)

func add_vcam(vcam):
	vcams.append(vcam)
	update_vcam(null)

func remove_vcam(vcam):
	var i = vcams.find(vcam)
	if i == -1:
		return
	vcams.remove(i)
	update_vcam(null)

func update_vcam(_vcam):
	vcams.sort_custom(self, "vcam_comparator")

func vcam_comparator(a, b):
	if a.priority > b.priority:
		return true
