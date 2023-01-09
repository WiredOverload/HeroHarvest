extends Control

export(int) var emergency_level = 10

func play(is_emergency: bool):
	$AnimationPlayer.play("warning")


func _on_EventListener_receive(arg):
	play(arg >= emergency_level)

func slow_time():
	Engine.time_scale = 0.25
	
func normal_time():
	Engine.time_scale = 1
