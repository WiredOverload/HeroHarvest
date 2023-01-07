extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Vector3) var move_speed = Vector3(5, 1, 5)
export(Vector3) var gravity = Vector3(0, -10, 0)
export(float) var resting_y_vel: float = -0.1

var velocity: Vector3 = Vector3(0, resting_y_vel, 0)

onready var anim_tree := $AnimationTree

var is_attacking = false
var anim_locked = false
var attack_queued = false
var attack_available = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input = Vector3()
	
	if not is_attacking:
		if Input.is_action_pressed("move_left"):
			input.x -= 1
			if !Input.is_action_pressed("move_right"):
				$Sprite.flip_h = true
		if Input.is_action_pressed("move_right"):
			input.x += 1
			if !Input.is_action_pressed("move_left"):
				$Sprite.flip_h = false
		if Input.is_action_pressed("move_up"):
			input.z -= 1
		if Input.is_action_pressed("move_down"):
			input.z += 1
	
	if Input.is_action_just_pressed("action_attack"):
		queue_attack()
	
	var vel = input * move_speed + velocity
	
	var _slide_result = move_and_slide(vel, Vector3.UP)
	
	velocity += gravity * delta
	if is_on_floor():
		velocity.y = resting_y_vel
	
	if vel.x > move_speed.x * 0.5:
		$VirtualCameraRight.active = true
		$VirtualCameraLeft.active = false
	
	if vel.x < -move_speed.x * 0.5:
		$VirtualCameraRight.active = false
		$VirtualCameraLeft.active = true
	
	var running = 1 if input.length_squared() != 0 else 0
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
