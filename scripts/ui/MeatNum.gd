extends RichTextLabel


#var managerScene := preload("res://scenes/Manager.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	self.text = managerScene.boots.size()


func _on_Menu_meats_changed(new):
	self.text = new
