extends RichTextLabel

onready var managerScene = $"../../../../Manager"#ah well
#var managerScene := preload("res://scenes/Manager.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if managerScene:
		self.text = String((managerScene.RPGAgility + managerScene.RPGBrawn + managerScene.RPGMind) / 6)
