extends "res://scripts/Goblin.gd"

var attack_ready = false


var arrow_scene := preload("res://scenes/entities/Fireball.tscn")
var arrow_speed: float = 10.0

var player_pos: Vector3 = Vector3()

func _ready():
	$AttackTimer.start()
	hit_points = 20
	current_hp = 20

func _get_move_target(target: Spatial):
	player_pos = target.global_translation
	return target.global_translation + (
		Vector3(2, 0, 0) if target.global_translation.x < global_translation.x
		else Vector3(-2, 0, 0))

func _perform_attack(player: Spatial, target_position: Vector3, at_target: bool):
	if attack_ready and not in_hitstun:
		attack_ready = false
		match randi() % 2:
			0:
				_perform_fireball()
			1:
				_perform_stomp()

func _perform_stomp():
	anim_tree["parameters/playback"].start("stomp")

func _perform_fireball():
	anim_tree["parameters/playback"].start("firebreathe")


func spit_fireball():
	var source = $AttackHitbox/FireballSource.global_translation
	var arrow = arrow_scene.instance()
	get_parent().add_child(arrow)
	arrow.global_translation = source
	arrow.accel = 5 * Vector3(rand_range(-1,1), rand_range(-1,1), rand_range(-1,1))
	arrow.velocity = (player_pos - source).normalized() * arrow_speed
	arrow.damages = "player"
	arrow.die_on_hit = true


func _on_AttackTimer_timeout():
	attack_ready = true


func end_attack():
	$AttackTimer.start()
	.end_attack()
