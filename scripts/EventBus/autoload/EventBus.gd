extends Node

var subscribers = {}

func subscribe(event_name: String, listener, listener_func: String):
	if not subscribers.has(event_name):
		subscribers[event_name] = []
	subscribers[event_name].append([listener, listener_func])

func unsubscribe(event_name: String, listener, listener_func: String):
	for i in range(0, subscribers[event_name].size()):
		var l = subscribers[event_name][i]
		if l[0] == listener && l[1] == listener_func:
			subscribers[event_name].remove(i)
			break

func emit(event_name: String, arg):
	for i in range(0, subscribers[event_name].size()):
		var l = subscribers[event_name][i]
		l[0].call(l[1], arg)
