extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Vector3) var move_speed = Vector3(5, 1, 5)
export(Vector3) var gravity = Vector3(0, -10, 0)
export(float) var resting_y_vel: float = -0.1

var velocity: Vector3 = Vector3(0, resting_y_vel, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input = Vector3()
	if Input.is_action_pressed("move_left"):
		$Sprite.play("run")
		$Sprite.flip_h = true
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		$Sprite.flip_h = false
		$Sprite.play("run")
		input.x += 1
	if Input.is_action_pressed("move_up"):
		$Sprite.play("run")
		input.z -= 1
	if Input.is_action_pressed("move_down"):
		$Sprite.play("run")
		input.z += 1
		
#	if input.x == 0 && input.z == 0:
#		$Sprite.play("idle")
		
	if Input.is_action_pressed("action_attack"):
		$Sprite.play("attack1")
		
	
	var vel = input * move_speed + velocity
	
	move_and_slide(vel, Vector3.UP)
	
	velocity += gravity * delta
	if is_on_floor():
		velocity.y = resting_y_vel
	
	$VirtualCameraRight.active = vel.x > move_speed * 0.5
	$VirtualCameraLeft.active = vel.x < -move_speed * 0.5
