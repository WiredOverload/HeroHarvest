extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float, 0.1, 100, 0.1) var move_speed: float = 5
export(Vector3) var gravity = Vector3(0, -10, 0)
export(float) var resting_y_vel: float = -0.1

var velocity: Vector3 = Vector3(0, resting_y_vel, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input = Vector3()
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_up"):
		input.z -= 1
	if Input.is_action_pressed("move_down"):
		input.z += 1
	
	var vel = input * move_speed + velocity
	
	move_and_slide(vel, Vector3.UP)
	
	velocity += gravity * delta
	if is_on_floor():
		velocity.y = resting_y_vel
