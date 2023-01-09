extends "res://scripts/Character.gd"

export(Array, String) var possible_drops = []
export(float) var drop_chance = 0.2
export(PackedScene) var item_scene = null

var level = 1 setget set_level

var move_speed = 0.75

func set_level(l):
	level = l
	hit_points = level
	current_hp = hit_points
	var atkspd = lerp(1, 2, (level - 1) / 9.0)
	set_action_speed(atkspd)
	move_speed = lerp(0.5, 2, (level - 1) / 9.0)

func _get_move_target(player):
	print("override this")

func _perform_attack(player: Spatial, target_position: Vector3, at_target: bool):
	print("override this")

func _character_process(delta):
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		var target = players[0]
		
		var target_position = _get_move_target(target)
		
		$NavigationAgent.set_target_location(target_position)
		
		var at_target = $NavigationAgent.is_navigation_finished()
		
		if not at_target and _can_move():
			var next_loc = $NavigationAgent.get_next_location()
			var input = next_loc - global_translation
			input.y = 0
			input = input.normalized()
			_apply_input(input * move_speed)
		
		facing = sign(target.global_translation.x - global_translation.x)
		if facing == 0:
			facing = 1
		
		_perform_attack(target, target_position, at_target)

func die():
	.die()
	_drop_item()
	EventBus.emit("enemy_death", null)

func _on_DeathTimer_timeout():
	queue_free()


func _drop_item():
	if possible_drops.size() == 0:
		return
	var roll = rand_range(0, 1)
	if roll > drop_chance:
		return
	
	var type = possible_drops[randi() % possible_drops.size()]
	
	var item = item_scene.instance()
	get_parent().add_child(item)
	item.global_translation = global_translation
	item.item_def = Item.ItemDef.new(type, level)
	item.toss()

