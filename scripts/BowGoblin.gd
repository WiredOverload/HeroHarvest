extends "res://scripts/Goblin.gd"

export(float) var keep_distance = 5

var current_target = null

func _reset_anim():
	._reset_anim()
	current_target = null

func _get_move_target(target: Spatial):
	if current_target == null:
		var roll = rand_range(-PI, PI)
		var dart = Vector3(cos(roll), 0, sin(roll))
		current_target = target.global_translation + dart * keep_distance
		print("target", current_target)
	return current_target

func _perform_attack(player: Spatial, target_position: Vector3):
	if not attack_queued and not is_attacking and not in_hitstun and target_position.distance_to(global_translation) < 0.25:
		queue_attack()

func launch_arrow():
	current_target = null
	print("twang")
