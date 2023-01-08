extends KinematicBody


export(Vector3) var base_move_speed = Vector3(5, 1, 2.5)
export(Vector3) var gravity = Vector3(0, -10, 0)
export(float) var resting_y_vel: float = -0.1

var velocity: Vector3 = Vector3(0, resting_y_vel, 0)

onready var anim_tree := $AnimationTree

var is_attacking = false
var anim_locked = false
var attack_queued = false
var attack_available = true

# base_move_speed squared
var bmss = base_move_speed * base_move_speed
var bmxz = base_move_speed.x * base_move_speed.z

func _character_process(delta):
	print("override this")
	pass

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

func _ready():
	anim_tree.active = true
	print(bmss)

func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	
	_character_process(delta)
	
	var _slide_result = move_and_slide(velocity, Vector3.UP)
	
	velocity += gravity * delta
	if is_on_floor():
		velocity.y = resting_y_vel
	
	var running = 1 if velocity.x != 0 || velocity.z != 0 else 0
	anim_tree["parameters/conditions/running"] = running
	anim_tree["parameters/conditions/not_running"] = not running

func update_attack_conditions():
	anim_tree["parameters/conditions/attack"] = attack_queued && attack_available

func queue_attack():
	attack_queued = true
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
	update_attack_conditions()

func set_anim_locked(v):
	anim_locked = v

func make_attack_available():
	attack_available = true
	update_attack_conditions()
