extends Area

var align_to_forward = true
var velocity = Vector3()
var accel = Vector3(0, -10, 0)
var damages = "player"
var disable_hit = false

var time

func _ready():
	time = OS.get_ticks_msec()

func _physics_process(delta):
	transform.origin += velocity * delta
	velocity += accel * delta
	
	if align_to_forward:
		var z = -velocity.normalized()
		var x = Vector3.UP.cross(z).normalized()
		var y = z.cross(x).normalized()
		transform.basis = Basis(x, y, z)


func _on_Projectile_body_entered(body: PhysicsBody):
	if body and body.is_in_group("character"):
		if not disable_hit and body.is_in_group(damages):
			body.apply_hit(null)
			disable_hit = true
	else:
		print("stuck")
		disable_hit = true
		monitoring = false
		velocity = Vector3()
		accel = Vector3()
		set_physics_process(false)
		$DestroyTimer.start()
		print("time ", (OS.get_ticks_msec() - time)/1000.0)


func _on_DestroyTimer_timeout():
	queue_free()
