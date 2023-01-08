extends "res://scripts/Goblin.gd"

export(float) var keep_distance = 5
export(float) var aim_area_radius := 1.0

var arrow_scene := preload("res://scenes/entities/Projectile.tscn")
var arrow_speed: float = 5.0

var current_target = null
var target_player = null

func _reset_anim():
	._reset_anim()
	current_target = null
	target_player = null

func _get_move_target(target: Spatial):
	if current_target == null:
		var dart = _random_dir()
		current_target = target.global_translation + dart * keep_distance
		target_player = target
	return current_target

func _perform_attack(player: Spatial, target_position: Vector3, at_target: bool):
	if at_target and not attack_queued and not is_attacking and not in_hitstun:
		queue_attack()

func launch_arrow():
	var start := global_translation
	# purposefully non-uniform
	var variance = _random_dir() * aim_area_radius * rand_range(0, 1)
	var dart: Vector3 = target_player.global_translation + variance
	
	var arrow = arrow_scene.instance()
	get_parent().add_child(arrow)
	arrow.launch(start, dart, arrow_speed, "player")
	
	current_target = null
	target_player = null

static func _random_dir() -> Vector3:
	var roll = rand_range(-PI, PI)
	return Vector3(cos(roll), 0, sin(roll))
