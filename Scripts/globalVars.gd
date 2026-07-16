extends Node

@onready var player: Player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var UpgradeObject = preload("res://Scenes/upgrade.tscn")
@onready var upgrade: int
@onready var score: int
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
signal UpdateScore(score: int)
signal VolcanoEnd

@onready var UpgradeObject = preload("res://Scenes/upgrade.tscn")

var checkpointPositions: Array[Vector2]
var actualCheckpoint: int = 0
var lives: int = 3
var death_restart_timer: Timer

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
	
	checkpointPositions.append(Vector2(416, 112))
	checkpointPositions.append(Vector2(1440, 112))
	checkpointPositions.append(Vector2(1995, 112))
	#camera.setPosition(checkpointPositions[1]) # check if checkpoints work

# função pra pausar o game
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"): 
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
	var u = UpgradeObject.instantiate() as Upgrade
	var main_scene = get_tree().current_scene
	u.position = position
	main_scene.add_child(u)

func stopCamera() -> void:
	StopCamera.emit()

func startCamera() -> void:
	StartCamera.emit()

func checkpointAchieved() -> void:
	actualCheckpoint += 1

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
	death_restart_timer = Timer.new()
	#shoot_timer.wait_time = 2.0
	death_restart_timer.one_shot = true
	death_restart_timer.timeout.connect(restartPlay)
	add_child(death_restart_timer)
	death_restart_timer.start(5.0)
	# talvez mais coisas a implementar aqui

func restartPlay() -> void:
	#print("vidas atuais: " + str(lives))
	if lives < 0:
		print("implementar voltar pro menu e salvar hiscore")
		actualCheckpoint = 0
		camera.setPosition(checkpointPositions[actualCheckpoint])
		resetPlayer()
		lives = 3
		# após criar os grupos de spawners pra cada checkpoint
		# chamar aqui pra ativar todos os da parte da fase referente ao checkpoint atual
	else:
		lives -= 1
		camera.setPosition(checkpointPositions[actualCheckpoint])
		resetPlayer()
		# após criar os grupos de spawners pra cada checkpoint
		# chamar aqui pra ativar todos os da parte da fase referente ao checkpoint atual

func resetPlayer() -> void:
	var playerInitialPosition:= Vector2(-45, -10)
	player.position = playerInitialPosition
	ZeroUpgrades.emit()
	if player.hadUpgrades() and lives >= 0: # n me lembro se o player tinha q ter ja, ou se ele tinha algum pra selecionar pra começar com 1 ja
		player.resetToFactory()
		getUpgrade()
	else:
		player.resetToFactory()

func adjustSpawners() -> void:
	pass # implementar aqui pra de acordo com o actualCheckpoint, ativar apenas os spawners do checkpoint atual dele

func canKonamiAgain() -> void:
	canUseCheat = true

func receiveScore(score_: int) -> void:
	score += score_
	UpdateScore.emit(score)
	
func VolcanoEndSpawning():
	VolcanoEnd.emit()
