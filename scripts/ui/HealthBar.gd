extends ProgressBar

func _on_EventListener_receive(arg):
	value = float(arg.current_hp) / arg.hit_points
