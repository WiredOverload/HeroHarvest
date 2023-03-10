extends KinematicBody


export(Vector3) var base_move_speed = Vector3(5, 1, 2.5)
export(Vector3) var gravity = Vector3(0, -10, 0)
export(float) var resting_y_vel: float = -0.1

export(float) var hitstun_duration: float = 1.0
export(float) var hit_nudge_impulse: float = 10

var velocity: Vector3 = Vector3(0, resting_y_vel, 0)
var impulse: Vector3 = Vector3()

onready var anim_tree: AnimationTree = $AnimationTree
onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_attacking = false
var anim_locked = false
var attack_queued = false
var attack_available = true
var attack_count = 0
var in_hitstun = false
var hitstun_combo = 0
var in_iframes = false

var hit_points = 1
var current_hp = hit_points

var facing = 1

var dead = false

# base_move_speed squared
var bmss = base_move_speed * base_move_speed
var bmxz = base_move_speed.x * base_move_speed.z

func _character_process(delta):
	print("override this")
	pass

func _reset_anim():
	print("resetting animation ", name)
	is_attacking = false
	anim_locked = false
	attack_queued = false
	attack_available = true
	attack_count = 0
	in_hitstun = false
	hitstun_combo = 0
	in_iframes = false
	update_attack_conditions()
	anim_tree["parameters/playback"].start("idle")
	$AttackHitbox/CollisionShape.disabled = true

func _apply_input(input: Vector3):
	var length = input.length()
	if length == 0:
		return
	var dir = input.normalized()
	var angle = atan2(dir.z, dir.x)
	var x = bmxz / (
		sqrt(bmss.z + bmss.x * pow(tan(angle), 2)))
	var z = sqrt((1 - (x*x / bmss.x)) * bmss.z)
	velocity.x += x * sign(input.x) * length
	velocity.z += z * sign(input.z) * length

func _can_move():
	return not is_attacking and not in_hitstun and not anim_locked

func _ready():
	anim_tree.active = true
	print(bmss)

func _physics_process(delta):
	if dead:
		return
	
	velocity.x = 0
	velocity.z = 0
	
	velocity += impulse
	impulse = Vector3()
	
	_character_process(delta)
	
	var _slide_result = move_and_slide(velocity, Vector3.UP)
	
	velocity += gravity * delta
	if is_on_floor():
		velocity.y = resting_y_vel
	
	var running = 1 if velocity.x != 0 || velocity.z != 0 else 0
	anim_tree["parameters/conditions/running"] = running
	anim_tree["parameters/conditions/not_running"] = not running
	
	$Sprite.flip_h = facing == -1
	$AttackHitbox.scale.x = facing

func update_attack_conditions():
	var s = "parameters/conditions/attack"
	for property in anim_tree.get_property_list():
		if property.name.begins_with(s):
			var i = int(property.name.trim_prefix(s))
			anim_tree[property.name] = attack_count == i && attack_queued && attack_available

func queue_attack():
	if not attack_queued:
		attack_queued = true
		attack_count += 1
	update_attack_conditions()

func begin_attack():
	is_attacking = true
	attack_queued = false
	attack_available = false
	update_attack_conditions()

func end_attack():
	is_attacking = false
	attack_available = true
	anim_locked = false
	attack_count = 0
	attack_queued = false
	$AttackHitbox/CollisionShape.disabled = true
	update_attack_conditions()

func set_anim_locked(v):
	anim_locked = v

func make_attack_available():
	attack_available = true
	update_attack_conditions()

func set_iframes(v):
	in_iframes = v

func _on_AttackHitbox_body_entered(body):
	if not body.is_in_group("character"):
		return
	
	var my_type = (
		"player" if is_in_group("player") else
		"enemy" if is_in_group("enemy") else
		"")
	var their_type = (
		"player" if body.is_in_group("player") else
		"enemy" if body.is_in_group("enemy") else
		"")
	if my_type != their_type:
		body.apply_hit(self)

func apply_hit(source):
	if in_iframes or dead:
		return
	if in_hitstun:
		hitstun_combo += 1
		$HitstunTimer.start($HitstunTimer.wait_time - hitstun_combo * $HitstunTimer.wait_time / 5)
	else:
		_reset_anim()
		anim_tree["parameters/playback"].start("hitstun")
		in_hitstun = true
		anim_locked = true
		hitstun_combo = 0
		$HitstunTimer.start()
	if source:
		impulse += (global_translation - source.global_translation).normalized() * hit_nudge_impulse
	if current_hp > 0:
		if is_in_group("player"):
			current_hp -= 1
			EventBus.emit("player_health_update", self)
		else:
			var dmg = 1 + floor(source.attackPower / 2)
			current_hp -= dmg
		if current_hp <= 0:
			die()

func reset_attack_count():
	attack_count = 0

func _on_HitstunTimer_timeout():
	if not dead:
		_reset_anim()

func die():
	dead = true
	current_hp = 0
	_reset_anim()
	anim_tree["parameters/playback"].start("death")
	$DeathTimer.start()
	$DeathSFX.play()

func set_action_speed(spd):
	if "parameters/attack1/TimeScale/scale" in $AnimationTree:
		$AnimationTree["parameters/attack1/TimeScale/scale"] = spd
	if "parameters/attack2/TimeScale/scale" in $AnimationTree:
		$AnimationTree["parameters/attack2/TimeScale/scale"] = spd
	if "parameters/dodgeroll/TimeScale/scale" in $AnimationTree:
		$AnimationTree["parameters/dodgeroll/TimeScale/scale"] = spd

