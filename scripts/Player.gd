extends "res://scripts/Character.gd"
class_name Player

export(String, "spear", "bow", "staff") var weapon = "spear" setget set_weapon

export(float) var anim_move_multiplier = 1.0

var locked_input = null

var weaponanims_spear = preload("res://assets/spritesheets/Heroine1/heroine_sm_spear.tres")
var weaponanims_bow = preload("res://assets/spritesheets/Ranger/ranger_sm_bow.tres")
var weaponanims_staff = preload("res://assets/spritesheets/Wizard/wizard_sm_staff.tres")

var arrow_scene := preload("res://scenes/entities/Projectile.tscn")
var arrow_speed: float = 10.0

var max_arrow_target_dist = 4.0

onready var managerScene = get_tree().root.find_node("Manager", true, false)

var level = 1 setget set_level
var attackPower = 0

func set_level(l):
	level = l
	hit_points = 3 + managerScene.RPGMind
	current_hp = hit_points
	var atkspd = 1 + managerScene.RPGAgility / 6 #lerp(1, 2, (level - 1) / 9)
	set_action_speed(atkspd)
	attackPower = managerScene.RPGBrawn

func set_weapon(w):
	weapon = w
	
	if is_inside_tree() and $AnimationTree:
		update_weapon()

func update_weapon():
	match weapon:
		"spear":
			$AnimationTree.tree_root = weaponanims_spear
		"bow":
			$AnimationTree.tree_root = weaponanims_bow
		"staff":
			$AnimationTree.tree_root = weaponanims_staff

func _ready():
	set_level(level)
	EventBus.emit("player_health_update", self)
	update_weapon()

func _character_process(delta):
	var input = Vector3()
	
	if locked_input:
		input = locked_input
	else:
		if Input.is_action_pressed("move_left"):
			input.x -= 1
			if !Input.is_action_pressed("move_right"):
				facing = -1
		if Input.is_action_pressed("move_right"):
			input.x += 1
			if !Input.is_action_pressed("move_left"):
				facing = 1
		if Input.is_action_pressed("move_up"):
			input.z -= 1
		if Input.is_action_pressed("move_down"):
			input.z += 1
		input = input.normalized()
	
	if Input.is_action_just_pressed("action_attack"):
		queue_attack()
	
	if not anim_locked and Input.is_action_just_pressed("action_dodge"):
		_reset_anim()
		$AnimationTree["parameters/playback"].start("dodgeroll")
		locked_input = input
		if locked_input.length_squared() == 0:
			locked_input = Vector3(facing, 0, 0)
	
	if _can_move() or locked_input:
		_apply_input(input * anim_move_multiplier)
	else:
		_apply_input(Vector3())
	
	if velocity.x > 0.5:
		$VirtualCameraRight.active = true
		$VirtualCameraLeft.active = false
	
	if velocity.x < -0.5:
		$VirtualCameraRight.active = false
		$VirtualCameraLeft.active = true

func end_roll():
	locked_input = null

func _reset_anim():
	._reset_anim()
	locked_input = null

func launch_arrow():
	var target_enemy = null
	var target_enemy_dist = max_arrow_target_dist
	
	var my_squished_pos = global_translation * Vector3(0.5, 1, 1)
	for x in get_tree().get_nodes_in_group("enemy"):
		if x.dead:
			continue
		var s = sign(x.global_translation.x - global_translation.x)
		if s == 0:
			s = 1
		if s == facing:
			var target_squished_pos = x.global_translation
			target_squished_pos *= Vector3(0.5, 1, 1)
			var d = target_squished_pos.distance_to(my_squished_pos)
			if d < target_enemy_dist:
				target_enemy_dist = d
				target_enemy = x
	
	var target_position = (
		target_enemy.global_translation if target_enemy
		else global_translation + Vector3(3, 0, 0) * facing)
	
	var start := global_translation
	
	var arrow = arrow_scene.instance()
	get_parent().add_child(arrow)
	arrow.accel.y *= 2
	arrow.launch(start, target_position, arrow_speed, "enemy")

func _single_fireball(v):
	var arrow = arrow_scene.instance()
	get_parent().add_child(arrow)
	arrow.global_translation = global_translation
	arrow.accel = Vector3(10 * facing, 0, 0)
	arrow.velocity = v
	arrow.damages = "enemy"
	arrow.die_on_hit = true

func launch_fireball():
	_single_fireball(Vector3(0, 0, 0))
	_single_fireball(Vector3(0, 0, 3))
	_single_fireball(Vector3(0, 0, -3))



func _on_DeathTimer_timeout():
	EventBus.emit("player_death", self)


func _on_ItemVacArea_item_entered(item):
	item.pull_to(self)

