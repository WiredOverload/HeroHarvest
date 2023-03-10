extends Navigation

export(int) var level: int = 1 setget set_level
export(int) var enemies_per_level = 5

var enemies_killed = 0

func set_level(l: int):
	level = l
	EventBus.emit("set_level", level)


func _on_EnemyDeathEventListener_receive(arg):
	enemies_killed += 1
	EventBus.emit("enemies_killed", enemies_killed)
	if level < 10 and enemies_killed >= enemies_per_level:
		next_level()

func next_level():
	enemies_killed = 0
	EventBus.emit("enemies_killed", enemies_killed)
	set_level(level + 1)
	EventBus.emit("next_level", level)

