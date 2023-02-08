extends Node

class RPGStats:
	var brawn: int
	var agility: int
	var mind: int
	func _init(b = 0, a = 0, m = 0):
		brawn = b
		agility = a
		mind = m

#player and RGP Gal stats

var player_stats := RPGStats.new(1, 1, 1)
var current_weapon := "spear"

var tama_stats := RPGStats.new()

var foods := []
var boots := []
var tomes := []


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	current_weapon = ["spear", "bow", "staff"][randi() % 3]



func _on_ItemGetEventListener_receive(arg: Item.ItemDef):
	match(arg.item_type):
		"food":
			foods.append(arg.item_level)
			foods.sort()
		"boot":
			boots.append(arg.item_level)
			boots.sort()
		"tome":
			tomes.append(arg.item_level)
			tomes.sort()


func harvest():
	player_stats.agility += tama_stats.agility
	player_stats.brawn += tama_stats.brawn
	player_stats.mind += tama_stats.mind
	
	var stat_priorities = [
		["brawn", tama_stats.brawn],
		["agility", tama_stats.agility],
		["mind", tama_stats.mind]]
	
	stat_priorities.shuffle()
	stat_priorities.sort_custom(self, "_stat_priorities_comparator")
	
	match stat_priorities[0][0]:
		"brawn":
			current_weapon = "spear"
		"agility":
			current_weapon = "bow"
		"mind":
			current_weapon = "bow"
	
	tama_stats = RPGStats.new()

func _stat_priorities_comparator(a, b):
	return a[1] > b[1]
