extends AnimatedSprite

#512 336 is 0,0
#472 -> 552
#312 -> 376

export (PackedScene) var foodScene

enum states {IDLE, AGILITY, BRAWN, MIND, FEED}
enum foods {MEAT, BOOKS, BOOTS}
var state = states.IDLE

var target = null
var speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.transform.origin = Vector2(512, 336)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(target != null):
		self.transform.origin += (target.transform.origin - self.transform.origin).normalized() * speed * delta
		#self.transform.origin.y += target.transform.origin.normalized().y * speed * delta
		if(abs(self.transform.origin.x - target.transform.origin.x) < .1 && 
			abs(self.transform.origin.y - target.transform.origin.y) < .1):
			#trigger stat gain
			target.queue_free()
			self.animation = "IDLE"
			target = null
	pass

func feed(var food):
	state = states.FEED
	self.animation = states.keys()[state]
	target = foodScene.instance()
	get_parent().add_child(target)
	target.transform.origin.x = rand_range(472, 552)
	target.transform.origin.y = rand_range(312, 376)
	target.get_node("AnimatedSprite").animation = foods.keys()[food];
	

func train(var activity):
	state = activity
	self.animation = states.keys()[state]


func _on_RPGGuy_visibility_changed():
	self.transform.origin.x = rand_range(472, 552)
	self.transform.origin.y = rand_range(312, 376)
