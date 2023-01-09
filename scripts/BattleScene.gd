extends Spatial

var player_scene: PackedScene = preload("res://scenes/characters/Player.tscn")
var forest_stage_scene: PackedScene = preload("res://scenes/stages/ForestStage.tscn")
var swamp_stage_scene: PackedScene = preload("res://scenes/stages/SwampStage.tscn")

var stage: Node = null
var player: Player = null

func create_stage(type: String, level: int) -> Player:
	if stage:
		print("ERROR: Stage already loaded")
		return player
	match type:
		"forest":
			stage = forest_stage_scene.instance()
		"swamp":
			stage = swamp_stage_scene.instance()
	add_child(stage)
	stage.level = level
	
	player = player_scene.instance()
	stage.add_child(player)
	
	var spawn_point = stage.find_node("PlayerSpawn")
	player.global_translation = spawn_point.global_translation
	
	return player

func destroy_stage():
	stage.queue_free()
	player = null
