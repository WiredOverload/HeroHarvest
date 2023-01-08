extends "res://scripts/Goblin.gd"

export(float) var keep_distance = 5
export(float) var aim_area_radius := 0.0

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

func _perform_attack(player: Spatial, target_position: Vector3):
	if not attack_queued and not is_attacking and not in_hitstun and target_position.distance_to(global_translation) < 0.25:
		queue_attack()

func launch_arrow():
	var start := global_translation
	var a = _random_dir() * aim_area_radius * sqrt(rand_range(0, 1))
	var dart: Vector3 = target_player.global_translation + a
	
	var dist := start.distance_to(dart)
	var t := dist / arrow_speed
	
	var arrow = arrow_scene.instance()
	get_parent().add_child(arrow)
	arrow.damages = "player"
	arrow.global_translation = start
	arrow.velocity = (dart - start).normalized() * arrow_speed
	arrow.velocity.y = -arrow.accel.y * t / 2.0
	
	current_target = null
	target_player = null

static func _random_dir() -> Vector3:
	var roll = rand_range(-PI, PI)
	return Vector3(cos(roll), 0, sin(roll))
