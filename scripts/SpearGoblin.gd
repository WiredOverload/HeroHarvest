extends "res://scripts/Goblin.gd"


func _get_move_target(target: Spatial):
	return target.global_translation + (
		Vector3(1, 0, 0) if target.global_translation.x < global_translation.x
		else Vector3(-1, 0, 0))

func _perform_attack(player: Spatial, target_position: Vector3, at_target: bool):
	if at_target and not in_hitstun:
		queue_attack()
