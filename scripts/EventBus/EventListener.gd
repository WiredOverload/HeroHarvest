extends Node
class_name EventListener

export(String) var event_name: String = ""

signal receive(arg)

func _on_eventbus_emit(arg):
	emit_signal("receive", arg)

func _enter_tree():
	EventBus.subscribe(event_name, self, "_on_eventbus_emit")

func _exit_tree():
	EventBus.unsubscribe(event_name, self, "_on_eventbus_emit")
