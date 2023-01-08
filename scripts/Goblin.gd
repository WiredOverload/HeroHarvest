extends "res://scripts/Character.gd"

func _character_process(delta):
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
	
	if velocity.x > 0.5:
		$VirtualCameraRight.active = true
		$VirtualCameraLeft.active = false
	
	if velocity.x < -0.5:
		$VirtualCameraRight.active = false
		$VirtualCameraLeft.active = true
