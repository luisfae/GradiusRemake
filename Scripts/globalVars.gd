extends Node

const MENU_SCENE_PATH = "res://Scenes/mainMenu.tscn"

@onready var player: Player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var UpgradeObject = preload("res://Scenes/upgrade.tscn")
@onready var Vulcan = preload("res://Scenes/volcano_spawner.tscn")
@onready var upgrade: int
@onready var score: int
@onready var hiscore: int = 10000 # no jogo original eh 50000, acho q 10k ta bom pra 1 nivel so
@onready var upgradesCreated: int
signal UpgradeSpeed
signal UpgradeMissile
signal UpgradeDouble
signal UpgradeLaser
signal UpgradeOption
signal UpgradeShield
signal UpgradeGet(upgrade: int)
signal ShieldDeactivated(upgrade: int)
signal ZeroUpgrades
signal StopCamera
signal StartCamera
signal KonamiCode
signal WakeBoss
signal KillAllEnemies
signal KillAllProjectiles
signal UpdateScore(score: int)
signal UpdateHiScore(hiscore: int) # usar pra atualizar o highscore
signal UpdateLives(lives: int)

var checkpointPositions: Array[Vector2]
var actualCheckpoint: int = 0
var lives: int = 3
var death_restart_timer: Timer
var resume_after_event: Timer
var gameplay: bool = false

# konami code things
const KONAMI_CODE: Array[String] = [
	"up", "up", "down", "down", 
	"left", "right", "left", "right", 
	"fire", "applyUpgrade"
]
var input_history: Array[String] = []
var cheatReady: bool = false
var canUseCheat: bool = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	score = 0
	UpdateScore.emit(score)
	UpdateHiScore.emit(hiscore)
	
	checkpointPositions.append(Vector2(416, 112))
	checkpointPositions.append(Vector2(1440, 112))
	checkpointPositions.append(Vector2(1995, 112))
	checkpointPositions.append(Vector2(2465, 112))
	#camera.setPosition(checkpointPositions[1]) # check if checkpoints work

# função pra pausar o game
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and gameplay: 
		togglePause()
	
	if get_tree().paused and event.is_pressed() and !event.is_echo():
		check_cheat_input(event)

func togglePause() -> void:
	get_tree().paused = !get_tree().paused
	if !get_tree().paused:
		print("Jogo Retomado!")
		if cheatReady and canUseCheat: # konami code things
			cheatReady = false
			canUseCheat = false
			KonamiCode.emit()
	else:
		AudioManager.play_sfx_gamePause()
		print("Jogo Pausado globalmente!")

func getUpgrade() -> void:
	upgrade += 1
	if upgrade > 6:
		upgrade = 1
	UpgradeGet.emit(upgrade)
	print("Upgrade: ", upgrade)

func applyUpgrade() -> void:
	match upgrade:
		0:
			print("Upgrade está zerado. Nada acontece feijoada")
			return
		1:
			print("Aplicando upgrade SpeedUp")
			UpgradeSpeed.emit()
			pass
		2:
			print("Aplicando upgrade Missile")
			UpgradeMissile.emit()
			pass
		3:
			print("Aplicando upgrade Double")
			UpgradeDouble.emit()
			pass
		4:
			print("Aplicando upgrade Laser")
			UpgradeLaser.emit()
			pass
		5:
			print("Aplicando upgrade Option")
			UpgradeOption.emit()
			pass
		6:
			print("Aplicando upgrade ?")
			UpgradeShield.emit()
			pass

func resetUpgrade() -> void:
	upgrade = 0
	UpgradeGet.emit(upgrade)

func deactivateShield() -> void:
	ShieldDeactivated.emit(upgrade)
	
func createUpgrade(position: Vector2) -> void:
	upgradesCreated += 1
	if upgradesCreated < 16:
		var u = UpgradeObject.instantiate() as Upgrade
		var main_scene = get_tree().current_scene
		u.position = position
		main_scene.add_child(u)
	else:
		upgradesCreated = 0
		var u = UpgradeObject.instantiate() as Upgrade
		var main_scene = get_tree().current_scene
		u.position = position
		main_scene.add_child(u)
		u.setKiller()

func getUpgradeKiller() -> void:
	for e in get_tree().get_nodes_in_group("Enemies"):
		e.takeHit()

func stopCamera() -> void:
	StopCamera.emit()

func startCamera() -> void:
	StartCamera.emit()

func checkpointAchieved() -> void:
	actualCheckpoint += 1
	if actualCheckpoint == 1:
		AudioManager.play_bgm_area_2()

func check_cheat_input(event: InputEvent) -> void:
	# Lista de ações que nos interessam monitorizar
	var valid_actions = ["up", "down", "left", "right", "applyUpgrade", "fire"]
	
	for action in valid_actions:
		if event.is_action_pressed(action):
			input_history.append(action)
			
			var current_index = input_history.size() - 1
			
			if input_history[current_index] != KONAMI_CODE[current_index]:
				print("codigo errado!")
				input_history.clear()
				# se o botão errado for "up", recomeça o historico com ele porque pode ser o início de uma nova tentativa
				if action == "up":
					input_history.append("up")
				return
			
			# se os sizes baterem, konami code activate
			if input_history.size() == KONAMI_CODE.size():
				cheatReady = true
				input_history.clear()
				print("KONAMI CODE ATIVADO!")
			
			break

func playerDied() -> void:
	AudioManager.stop_music()
	death_restart_timer = Timer.new()
	#shoot_timer.wait_time = 2.0
	death_restart_timer.one_shot = true
	death_restart_timer.timeout.connect(restartPlay)
	add_child(death_restart_timer)
	death_restart_timer.start(5.0)
	if lives <= 0:
		pass # chamar aqui pra mudar o hud pra GAME OVER

func restartPlay() -> void:
	#print("vidas atuais: " + str(lives))
	if lives <= 0:
		print("implementar voltar pro menu e salvar hiscore")
		actualCheckpoint = 0
		lives = 3
		gameplay = false
		score = 0
		upgradesCreated = 0
		resetPlayer()
		upgrade = 0
		get_tree().change_scene_to_file(MENU_SCENE_PATH)
	else:
		lives -= 1
		# Limpeza do grupo "Enemies"
		KillAllEnemies.emit()
		# Limpeza do grupo "Enemy Projectiles"
		KillAllProjectiles.emit()
		
		adjustSpawners()
		UpdateLives.emit(lives)
		camera = get_viewport().get_camera_2d()
		camera.setPosition(checkpointPositions[actualCheckpoint])
		resetPlayer()
		startCamera()
		if actualCheckpoint == 0:
			AudioManager.play_bgm_area_1()
		elif actualCheckpoint > 0:
			AudioManager.play_bgm_area_2()

func adjustSpawners() -> void:
	match actualCheckpoint:
			0:
				var spawners = get_tree().get_nodes_in_group("Spawns Checkpoint1")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint2")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint3")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint4")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
			1:
				var spawners = get_tree().get_nodes_in_group("Spawns Checkpoint1")
				for spawner in spawners:
					if spawner.has_method("setInactive"):
						spawner.setInactive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint2")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint3")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint4")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
			2:
				var spawners = get_tree().get_nodes_in_group("Spawns Checkpoint1")
				for spawner in spawners:
					if spawner.has_method("setInactive"):
						spawner.setInactive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint2")
				for spawner in spawners:
					if spawner.has_method("setInactive"):
						spawner.setInactive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint3")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint4")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
			3:
				var spawners = get_tree().get_nodes_in_group("Spawns Checkpoint1")
				for spawner in spawners:
					if spawner.has_method("setInactive"):
						spawner.setInactive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint2")
				for spawner in spawners:
					if spawner.has_method("setInactive"):
						spawner.setInactive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint3")
				for spawner in spawners:
					if spawner.has_method("setInactive"):
						spawner.setInactive()
				spawners = get_tree().get_nodes_in_group("Spawns Checkpoint4")
				for spawner in spawners:
					if spawner.has_method("setActive"):
						spawner.setActive()
				var eventcps = get_tree().get_nodes_in_group("Event Checkpoints")
				for eventcp in eventcps:
					if eventcp.has_method("setActive"):
						eventcp.setActive()

func resetPlayer() -> void:
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	var playerInitialPosition:= Vector2(-45, -10)
	player.position = playerInitialPosition
	ZeroUpgrades.emit()
	resetUpgrade()
	if (player.hadUpgrades() or upgrade > 0) and lives >= 0: # n me lembro se o player tinha q ter ja, ou se ele tinha algum pra selecionar pra começar com 1 ja
		player.resetToFactory()
		getUpgrade()
	else:
		player.resetToFactory()

func canKonamiAgain() -> void:
	canUseCheat = true

func receiveScore(score_: int) -> void:
	score += score_
	UpdateScore.emit(score)
	if score > hiscore:
		hiscore = score
		UpdateHiScore.emit(hiscore) # chamar aqui pra dar update no highscore

func lifeUp() -> void:
	lives += 1
	UpdateLives.emit(lives)

func VolcanoEndSpawning() -> void:
	#resume_after_vulcan
	resume_after_event = Timer.new()
	#shoot_timer.wait_time = 2.0
	resume_after_event.one_shot = true
	resume_after_event.timeout.connect(startCamera)
	add_child(resume_after_event)
	resume_after_event.start(1.0)

func startVolcanoEvent() -> void:
	stopCamera()
	var position := Vector2(3424, 154)
	var v = Vulcan.instantiate() as Volcano
	var main_scene = get_tree().current_scene
	v.position = position
	main_scene.add_child(v)
	
	position = Vector2(3552, 154)
	v = Vulcan.instantiate() as Volcano
	v.position = position
	main_scene.add_child(v)
	AudioManager.play_bgm_area_3()

func startBossEvent() -> void:
	stopCamera()
	WakeBoss.emit()

func endBossEvent() -> void:
	resume_after_event = Timer.new()
	resume_after_event.one_shot = true
	resume_after_event.timeout.connect(startCamera)
	add_child(resume_after_event)
	resume_after_event.start(1.0)

func goBackToMenu() -> void:
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
