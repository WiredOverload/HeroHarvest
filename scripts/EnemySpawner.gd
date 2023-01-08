extends Spatial

export(Array, PackedScene) var possible_enemies = []
export(Array, int) var possible_enemies_reqlevel = []
export(Array, float) var possible_enemies_weight = []

var current_level = 1

func _ready():
	$SpawnTimer.start()


func _on_DisablingArea_body_entered(body):
	if body.is_in_group("player"):
		$SpawnTimer.paused = true


func _on_DisablingArea_body_exited(body):
	if body.is_in_group("player"):
		$SpawnTimer.paused = false


func _on_SpawnTimer_timeout():
	var pis = []
	for x in range(0, possible_enemies.size()):
		if possible_enemies_reqlevel[x] <= current_level:
			pis.append(x)
	if pis.size() == 0:
		print("Oopsie! No enemies to spawn!")
		return
	var total_weight = 0
	for i in pis:
		total_weight += possible_enemies_weight[i]
	var roll = rand_range(0, total_weight)
	for i in pis:
		roll -= possible_enemies_weight[i]
		if roll <= 0:
			_spawn_enemy(i)
			return
	_spawn_enemy(pis[0])

func _spawn_enemy(i: int):
	var e = possible_enemies[i].instance()
	get_parent().add_child(e)
	e.global_translation = global_translation
