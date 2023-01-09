extends Node


#player and RGP Gal stats
var playerAttack;
var playerMaxHealth;
var playerDefense;

var RPGAttack;
var RPGMaxHealth;
var RPGDefense;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemGetEventListener_receive(arg: Item.ItemDef):
	pass # Replace with function body.
