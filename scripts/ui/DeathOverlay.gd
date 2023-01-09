extends TextureRect

func _ready():
	visible = false

func _on_EventListener_receive(arg):
	visible = true


func _on_EventListener2_receive(arg):
	visible = false
