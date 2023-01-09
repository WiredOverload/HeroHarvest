extends Control



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
