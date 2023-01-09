extends Control

func play(is_emergency: bool):
	print("adsf")
	$AnimationPlayer.play("warning")


func _on_EventListener_receive(arg):
	play(arg)

func slow_time():
	Engine.time_scale = 0.25
	
func normal_time():
	Engine.time_scale = 1
