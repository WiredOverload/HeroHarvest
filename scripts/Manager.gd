extends Node


#player and RGP Gal stats
var playerAttack = 0;
var playerMaxHealth = 0;
var playerDefense = 0;

var RPGAgility = 0;
var RPGBrawn = 0;
var RPGMind = 0;

signal boots_changed(new)
signal meats_changed(new)
signal books_changed(new)

var meats = [] setget meats_set, meats_get
func meats_set(new):
	meats = new
	emit_signal("meats_changed", new)
func meats_get():
	if(meats):
		return meats
	else:
		return []
		
var boots = [] setget boots_set, boots_get
func boots_set(new):
	boots = new
	emit_signal("boots_changed", new)
func boots_get():
	if(boots):
		return boots
	else:
		return []
		
var books = [] setget books_set, books_get
func books_set(new):
	books = new
	emit_signal("books_changed", new)
func books_get():
	if(books):
		return books
	else:
		return []



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemGetEventListener_receive(arg: Item.ItemDef):
	match(arg.item_type):
		"food":
			meats.append(arg.item_level)
		"boot":
			boots.append(arg.item_level)
		"tome":
			books.append(arg.item_level)
