extends Node


#player and RGP Gal stats
var playerBrawn = 1;
var playerAgility = 1;
var playerMind = 1;
var current_weapon = ["spear", "bow", "staff"][randi() % 3]

var RPGAgility = 0;
var RPGBrawn = 0;
var RPGMind = 0;

signal boots_changed(new)
signal meats_changed(new)
signal books_changed(new)

var meats = [] setget meats_set
func meats_set(new):
	meats = new
	emit_signal("meats_changed", new)
		
var boots = [] setget boots_set
func boots_set(new):
	boots = new
	emit_signal("boots_changed", new)
		
var books = [] setget books_set
func books_set(new):
	books = new
	emit_signal("books_changed", new)



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	current_weapon = ["spear", "bow", "staff"][randi() % 3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemGetEventListener_receive(arg: Item.ItemDef):
	match(arg.item_type):
		"food":
			meats.append(arg.item_level)
			meats_set(meats)
		"boot":
			boots.append(arg.item_level)
			boots_set(boots)
		"tome":
			books.append(arg.item_level)
			books_set(books)


func _on_Menu_harvest():
	playerAgility += RPGAgility
	playerBrawn += RPGBrawn
	playerMind += RPGMind
	
	if RPGAgility >= RPGBrawn && RPGAgility >= RPGMind:
		current_weapon = "bow"
	elif RPGBrawn >= RPGMind:
		current_weapon = "spear"
	else:
		current_weapon = "staff"
	
	RPGAgility = 0
	RPGBrawn = 0
	RPGMind = 0
