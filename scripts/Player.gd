extends "res://scripts/Character.gd"

func _ready():
	hit_points = 3
	current_hp = 3
	EventBus.emit("player_health_update", self)

func _character_process(delta):
	var input = Vector3()
	
	if _can_move():
		if Input.is_action_pressed("move_left"):
			input.x -= 1
			if !Input.is_action_pressed("move_right"):
				$Sprite.flip_h = true
				$AttackHitbox.scale.x = -1
		if Input.is_action_pressed("move_right"):
			input.x += 1
			if !Input.is_action_pressed("move_left"):
				$Sprite.flip_h = false
				$AttackHitbox.scale.x = 1
		if Input.is_action_pressed("move_up"):
			input.z -= 1
		if Input.is_action_pressed("move_down"):
			input.z += 1
	
	if Input.is_action_just_pressed("action_attack"):
		queue_attack()
	
	_apply_input(input.normalized())
	
	if velocity.x > 0.5:
		$VirtualCameraRight.active = true
		$VirtualCameraLeft.active = false
	
	if velocity.x < -0.5:
		$VirtualCameraRight.active = false
		$VirtualCameraLeft.active = true
