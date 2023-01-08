extends Control

"""
List of Actions:
Feed RPG gal collected materials
Pick RPG gal training
Go out to get materials
Harvest RPG gal
Start final boss battle

Play idle animation until button is pressed
Display Care, Harvest, or explore options
"""

enum menus {MAIN, TRAIN, FEED, EXPLORE, HARVEST}

var menu = menus.MAIN;
var menuSelection = 0;

onready var animation = $MenuSelection;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#CANCEL
func _on_LeftButton_pressed():
	menu = menus.MAIN;
	menuSelection = 0;
	
	animation.animation = menus.keys()[menu];
	animation.frame = menuSelection;

#DOWN ARROW
func _on_CenterButton_pressed():
	menuSelection += 1;
	
	match (menu):
		menus.MAIN:
			if(menuSelection > 3):
				menuSelection = 0;
		menus.TRAIN:
			if(menuSelection > 2):
				menuSelection = 0;
		menus.HARVEST:
			if(menuSelection > 1):
				menuSelection = 0;
	
	animation.frame = menuSelection;
	

#ENTER
func _on_RightButton_pressed():
	match (menu):
		menus.MAIN:
			if(menuSelection == 0):
				menu = menus.TRAIN;
			if(menuSelection == 2):
				menu = menus.EXPLORE;
			if(menuSelection == 2):
				menu = menus.HARVEST;
			menuSelection = 0;
		menus.TRAIN:
			if(menuSelection == 0):
				#agility
				pass
			if(menuSelection == 1):
				#brawn
				pass
			if(menuSelection == 2):
				#mind
				pass
		menus.FEED:
			#feed
			pass
		menus.HARVEST:
			if(menuSelection == 0): #vs RPG gal
				get_tree().change_scene("res://Scenes/BattleScene.tscn");
			if(menuSelection == 1): #vs end boss
				get_tree().change_scene("res://Scenes/BattleScene.tscn");
		menus.EXPLORE:
			get_tree().change_scene("res://Scenes/BattleScene.tscn");
	
	animation.animation = menus.keys()[menu];
