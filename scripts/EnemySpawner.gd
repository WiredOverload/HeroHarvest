extends Spatial

export(int) var max_spawned_enemies = 10
export(Array, PackedScene) var possible_enemies = []
export(Array, int) var possible_enemies_reqlevel = []
export(Array, float) var possible_enemies_weight = []

var current_level = 1

func _ready():
	_restart_timer()

func _restart_timer():
	$SpawnTimer.start($SpawnTimer.wait_time + rand_range(0, 1))

func _on_DisablingArea_body_entered(body):
	if body.is_in_group("player"):
		$SpawnTimer.paused = true

func _on_DisablingArea_body_exited(body):
	if body.is_in_group("player"):
		$SpawnTimer.paused = false


func _on_SpawnTimer_timeout():
	_restart_timer()
	var num_enemies = get_tree().get_nodes_in_group("enemy").size()
	if num_enemies >= max_spawned_enemies:
		return
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
	e.level = current_level



func _on_SetLevelEventListener_receive(arg):
	current_level = arg
