extends Area

signal item_entered(item)

func _on_ItemVacArea_body_entered(body):
	if body.is_in_group("item"):
		emit_signal("item_entered", body)
