extends Node2D
class_name GroupEnemies
# fiquei com medo de usar o nome group pq existem os grupos e tal, vai q da problema


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if checkSpawners():
		var numEnemies = countEnemies()
		if numEnemies < 2 and numEnemies > 0:
			var lastOne
			for enemies in self.get_children():
				if !enemies.name.contains("Spawner"):
					lastOne = enemies
			if !lastOne.dropUpgrade:
				print("tentou setar upgrade")
				lastOne.setDropUpgrade()
			pass

# Essas duas proximas funções e toda essa complicação no process, é só pra nao deletar os groups e spawners pra talvez reaproveita-los
func countEnemies() -> int:
	var numberEnemies: int = 0
	for enemies in self.get_children():
		if enemies.name.contains("Spawner"):
			pass
		else:
			numberEnemies += 1
	return numberEnemies

func checkSpawners() -> bool:
	for childs in self.get_children():
		if childs.name.contains("Spawner"):
			if !childs.active:
				pass
			else:
				return false
		else:
			pass
	return true

			
#				⡴⠑⡄⠀⠀⠀⠀⠀⠀⠀ ⣀⣀⣤⣤⣤⣀⡀
#				⠸⡇⠀⠿⡀⠀⠀⠀⣀⡴⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀
#				⠀⠀⠀⠀⠑⢄⣠⠾⠁⣀⣄⡈⠙⣿⣿⣿⣿⣿⣿⣿⣿⣆
#				⠀⠀⠀⠀⢀⡀⠁⠀⠀⠈⠙⠛⠂⠈⣿⣿⣿⣿⣿⠿⡿⢿⣆
#				⠀⠀⠀⢀⡾⣁⣀⠀⠴ ⠙⣗⡀⠀⢻⣿⣿⠭⢤⣴⣦⣤⣹⠀⠀⠀⢀⢴⣶⣆
#				⠀⠀⢀⣾⣿⣿⣿⣷⣮⣽⣾⣿⣥⣴⣿⣿⡿⢂⠔⢚⡿⢿⣿⣦⣴⣾⠸⣼⡿
#				⠀⢀⡞⠁⠙⠻⠿⠟⠉⠀⠛⢹⣿⣿⣿⣿⣿⣌⢤⣼⣿⣾⣿⡟⠉
#				⠀⣾⣷⣶⠇⠀⠀⣤⣄⣀⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
#				⠀⠉⠈⠉⠀⠀⢦⡈⢻⣿⣿⣿⣶⣶⣶⣶⣤⣽⡹⣿⣿⣿⣿⡇
#				⠀⠀⠀⠀⠀⠀⠀⠉⠲⣽⡻⢿⣿⣿⣿⣿⣿⣿⣷⣜⣿⣿⣿⡇
#				⠀⠀ ⠀⠀⠀⠀⠀⢸⣿⣿⣷⣶⣮⣭⣽⣿⣿⣿⣿⣿⣿⣿⠇
#				⠀⠀⠀⠀⠀⠀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇
#				⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
