extends TextureRect

func _ready():
	visible = false

func _on_EventListener_receive(arg):
	visible = true
