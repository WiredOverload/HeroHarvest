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

enum menus {MAIN, CARE, HARVEST, EXPLORE};

var menu = menus.MAIN;
var menuSelection = 0;

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

#DOWN ARROW
func _on_CenterButton_pressed():
	menuSelection += 1;
	
	match (menu):
		menus.MAIN:
			if(menuSelection > 2):
				menuSelection = 0;
		menus.CARE:
			if(menuSelection > 1):
				menuSelection = 0;
		menus.HARVEST:
			if(menuSelection > 1):
				menuSelection = 0;

#ENTER
func _on_RightButton_pressed():
	match (menu):
		menus.MAIN:
			if(menuSelection == 0):
				menu = menus.CARE;
			if(menuSelection == 1):
				menu = menus.HARVEST;
			if(menuSelection == 2):
				menu = menus.EXPLORE;
			pass
		menus.CARE:
			if(menuSelection == 0):
				#train, needs submenu I guess
				pass
			if(menuSelection == 1):
				#feed
				pass
		menus.HARVEST:
			if(menuSelection == 0): #vs RPG gal
				get_tree().change_scene("res://Scenes/BattleScene.tscn");
			if(menuSelection == 1): #vs end boss
				get_tree().change_scene("res://Scenes/BattleScene.tscn");
		menus.EXPLORE:
			get_tree().change_scene("res://Scenes/BattleScene.tscn");
