extends "res://scripts/Character.gd"

func _character_process(delta):
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		var target = players[0]
		var target_position = target.global_translation + (
			Vector3(1, 0, 0) if target.global_translation.x < global_translation.x
			else Vector3(-1, 0, 0))
		
		if _can_move():
			var input = target_position - global_translation
			input.y = 0
			input = input.normalized()
			_apply_input(input)
		
		if global_translation.x - target.global_translation.x > 0:
			$Sprite.flip_h = true
			$AttackHitbox.scale.x = -1
		if global_translation.x - target.global_translation.x < 0:
			$Sprite.flip_h = false
			$AttackHitbox.scale.x = 1
		
		if not in_hitstun and target_position.distance_to(global_translation) < 0.25:
			queue_attack()
