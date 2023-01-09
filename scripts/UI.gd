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
var isVisible = false

onready var animation = $MenuSelection;
onready var RPGGuy = $"../RPGGuy";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#CANCEL
func _on_LeftButton_pressed():
	if(!isVisible):
		firstButtonPressed()
		return
	
	if(isVisible && menu == menus.MAIN):
		menuSelection = 0;
		isVisible = false
		RPGGuy.show()
		animation.hide()
		return
	
	menu = menus.MAIN;
	menuSelection = 0;
	
	animation.animation = menus.keys()[menu];
	animation.frame = menuSelection;
	

#DOWN ARROW
func _on_CenterButton_pressed():
	if(!isVisible):
		firstButtonPressed()
		return
	
	menuSelection += 1
	
	match (menu):
		menus.MAIN:
			if(menuSelection > 3):
				menuSelection = 0
		menus.TRAIN:
			if(menuSelection > 2):
				menuSelection = 0
		menus.HARVEST:
			if(menuSelection > 1):
				menuSelection = 0
	
	animation.frame = menuSelection
	
	RPGGuy.hide()
	animation.show()

#ENTER
func _on_RightButton_pressed():
	if(!isVisible):
		firstButtonPressed()
		return
	
	match (menu):
		menus.MAIN:
			if(menuSelection == 0):
				menu = menus.TRAIN;
			if(menuSelection == 1):
				RPGGuy.feed()
				isVisible = false
				RPGGuy.show()
				animation.hide()
			if(menuSelection == 2):
				menu = menus.EXPLORE;
			if(menuSelection == 3):
				menu = menus.HARVEST;
			menuSelection = 0;
		menus.TRAIN:
			if(menuSelection == 0):
				RPGGuy.train(RPGGuy.states.AGILITY)
				pass
			if(menuSelection == 1):
				RPGGuy.train(RPGGuy.states.BRAWN)
				pass
			if(menuSelection == 2):
				RPGGuy.train(RPGGuy.states.MIND)
				pass
			isVisible = false
			RPGGuy.show()
			animation.hide()
		menus.HARVEST:
			if(menuSelection == 0): #vs RPG gal
				get_tree().change_scene("res://Scenes/BattleScene.tscn");
			if(menuSelection == 1): #vs end boss
				get_tree().change_scene("res://Scenes/BattleScene.tscn");
		menus.EXPLORE:
			get_tree().change_scene("res://Scenes/BattleScene.tscn");
	
	animation.animation = menus.keys()[menu];

func firstButtonPressed():
	isVisible = true
	menu = menus.MAIN;
	menuSelection = 0;
	RPGGuy.hide()
	animation.show()
	animation.animation = menus.keys()[menu]
	animation.frame = menuSelection
