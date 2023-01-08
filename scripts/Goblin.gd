extends "res://scripts/Character.gd"

func _get_move_target(player):
	print("override this")

func _perform_attack(player: Spatial, target_position: Vector3):
	print("override this")

func _character_process(delta):
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		var target = players[0]
		
		var target_position = _get_move_target(target)
		
		if _can_move():
			var input = target_position - global_translation
			input.y = 0
			input = input.normalized()
			_apply_input(input)
		
		facing = sign(target.global_translation.x - global_translation.x)
		if facing == 0:
			facing = 1
		
		_perform_attack(target, target_position)
