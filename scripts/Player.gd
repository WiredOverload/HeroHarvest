extends "res://scripts/Character.gd"

var dodge_speed_multiplier = 1.2

var locked_input = null

func _ready():
	hit_points = 3
	current_hp = 3
	EventBus.emit("player_health_update", self)

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
		locked_input *= dodge_speed_multiplier
	
	if _can_move() or locked_input:
		_apply_input(input)
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

