extends KinematicBody
class_name Item

class ItemDef:
	var item_type = "food"
	var item_level = 1

var item_def: ItemDef = ItemDef.new()

var consumed = false

var velocity = Vector3(5, 5, 0)
var gravity = Vector3(0, -10, 0)

func _physics_process(delta):
	if consumed:
		return
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity.y = -velocity.y * 0.5
	velocity.x *= pow(0.5, delta)
	velocity.z *= pow(0.5, delta)
	velocity += gravity * delta


func _on_Area_body_entered(body):
	if consumed:
		return
	if body.is_in_group("player"):
		consumed = true
		EventBus.emit("item_get", item_def)
		queue_free()

