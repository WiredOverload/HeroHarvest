extends KinematicBody
class_name Item

class ItemDef:
	var item_type = "food"
	var item_level = 1
	func _init(type: String, level: int):
		item_type = type
		item_level = level

export(Array, String) var item_names = []
export(Array, Texture) var item_textures = []
export(Texture) var default_texture = null

var item_def: ItemDef = ItemDef.new("food", 1) setget set_item_def

var consumed = false

var velocity = Vector3(5, 5, 0)
var gravity = Vector3(0, -10, 0)

func set_item_def(def: ItemDef):
	item_def = def
	var i = item_names.find(def.item_type)
	if i == -1:
		$Sprite.texture = default_texture
	else:
		$Sprite.texture = item_textures[i]

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

func toss():
	velocity = velocity.rotated(Vector3(0, 1, 0), rand_range(-PI, PI))
	velocity *= Vector3(1, 0, 1) * sqrt(rand_range(0, 1))

