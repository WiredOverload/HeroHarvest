extends Area



func _on_KillPlane_body_entered(body):
	if body.is_in_group("character"):
		body.die()
