extends Area

var align_to_forward = true
var velocity = Vector3()
var accel = Vector3(0, -10, 0)
var damages = "player"
var disable_hit = false

func launch(from: Vector3, to: Vector3, arrow_speed: float, dmg: String):
	var start = from * Vector3(1, 0, 1)
	var dart = to * Vector3(1, 0, 1)
	
	var dist := to.distance_to(from)
	var t := dist / arrow_speed
	
	damages = dmg
	global_translation = from
	velocity = (dart - start).normalized() * arrow_speed
	velocity.y = (to.y - from.y) * 0.5 / t - accel.y * t / 2.0

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


func _on_DestroyTimer_timeout():
	queue_free()
