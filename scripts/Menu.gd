extends Control

export(NodePath) var battle_scene_node: NodePath = ""
onready var battle_scene = get_node(battle_scene_node)

signal boots_changed(new)
signal meats_changed(new)
signal books_changed(new)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Manager_books_changed(new):
	emit_signal("books_changed", new)


func _on_Manager_boots_changed(new):
	emit_signal("boots_changed", new)


func _on_Manager_meats_changed(new):
	emit_signal("meats_changed", new)

func explore(type: String):
	battle_scene.create_stage(type, 1)



func _on_UI_request_explore(type):
	explore(type)
	visible = false


func _on_EventListener_receive(arg):
	$DeathTimer.start()


func _on_DeathTimer_timeout():
	battle_scene.destroy_stage()
	visible = true
	$UI.menu




func _on_EventListener_tree_exiting():
	pass
