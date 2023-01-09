extends AnimatedSprite

#512 336 is 0,0
#472 -> 552
#312 -> 376

enum states {IDLE, AGILITY, BRAWN, MIND, FEED}
var state = states.IDLE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func feed():
	state = states.FEED
	self.animation = states.keys()[state]

func train(var activity):
	state = activity
	self.animation = states.keys()[state]
