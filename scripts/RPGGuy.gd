extends Control

#512 336 is 0,0
#472 -> 552
#312 -> 376

export (PackedScene) var foodScene
#var managerScene := preload("res://scenes/Manager.tscn")
onready var managerScene = $"../../../../../../Manager"

enum states {IDLE, AGILITY, BRAWN, MIND, FEED}
enum foods {MEAT, BOOKS, BOOTS}
var state = states.IDLE

var targets = []
var speed = 10.0

signal agility_changed(new)
signal brawn_changed(new)
signal mind_changed(new)
signal level_changed(new)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_position = Vector2(512, 336)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(targets.size() > 0):
		self.rect_position += (targets[0].transform.origin - self.rect_position).normalized() * speed * delta
		#self.rect_position.y += target.transform.origin.normalized().y * speed * delta
		if(abs(self.rect_position.x - targets[0].transform.origin.x) < .1 && 
			abs(self.rect_position.y - targets[0].transform.origin.y) < .1):
			match(targets[0].type):
				foods.MEAT:
					managerScene.RPGBrawn += targets[0].power
				foods.BOOTS:
					managerScene.RPGAgility += targets[0].power
				foods.BOOKS:
					managerScene.RPGMind += targets[0].power
			targets[0].queue_free()
			state = states.IDLE
			$GuySprite.animation = "IDLE"
			targets.pop_front()
	pass

func feed(var food):
	state = states.FEED
	$GuySprite.animation = states.keys()[state]
	var target = foodScene.instance()
	get_parent().add_child(target)
	target.transform.origin.x = rand_range(472, 552)
	target.transform.origin.y = rand_range(312, 376)
	target.get_node("AnimatedSprite").animation = foods.keys()[food];
	match(food):
		foods.MEAT:
			target.power = managerScene.meats[0]
			managerScene.meats.pop_front()
		foods.BOOTS:
			target.power = managerScene.boots[0]
			managerScene.boots.pop_front()
		foods.BOOKS:
			target.power = managerScene.books[0]
			managerScene.books.pop_front()
	
	targets.append(target)

func train(var activity):
	state = activity
	$GuySprite.animation = states.keys()[state]
	$TrainTimer.start()


func _on_RPGGuy_visibility_changed():
	if(state != states.FEED):
		self.rect_position.x = rand_range(472, 552)
		self.rect_position.y = rand_range(312, 376)


func _on_TrainTimer_timeout():
	#if(state != states.IDLE):
	match(state):
		states.AGILITY:
			managerScene.RPGAgility += 1
		states.BRAWN:
			managerScene.RPGBrawn += 1
		states.MIND:
			managerScene.RPGMind += 1
	state = states.IDLE
	$GuySprite.animation = states.keys()[state]
